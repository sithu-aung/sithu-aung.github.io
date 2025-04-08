# WebRTC Selective Forwarding Unit (SFU) WebSocket Server Explained

This document provides a detailed explanation of the WebRTC SFU (Selective Forwarding Unit) WebSocket server implementation in Go. This server allows multiple broadcasters to stream audio and video content to viewers in separate virtual rooms.

## Table of Contents

- [Introduction](#introduction)
- [Core Data Structures](#core-data-structures)
- [Main Function and Server Setup](#main-function-and-server-setup)
- [Room Management](#room-management)
- [Track Management](#track-management)
- [WebSocket Connection Handling](#websocket-connection-handling)
- [WebRTC Signaling](#webrtc-signaling)
- [Media Relay](#media-relay)
- [Connection Management](#connection-management)
- [Utility Functions](#utility-functions)
- [Real-World Examples](#real-world-examples)
- [Go Syntax Highlights](#go-syntax-highlights)

## Introduction

This Go server implements a WebRTC Selective Forwarding Unit (SFU) with WebSocket signaling that enables many-to-many video broadcasting. The server organizes connections into virtual "rooms" where broadcasters can stream content and viewers can watch.

Key features of this SFU implementation:
- Room-based broadcasting with dynamic room creation
- Support for one broadcaster and multiple viewers per room
- Efficient media relay from broadcasters to viewers
- Complete WebRTC signaling via WebSockets
- Automatic keyframe requests for improved video quality
- Room listing API for discovery
- Graceful server shutdown

## Core Data Structures

### roomState

```go
type roomState struct {
    broadcaster  *peerConnectionState  // Only one broadcaster per room
    viewers      []peerConnectionState // Multiple viewers
    trackLocals  map[string]*webrtc.TrackLocalStaticRTP
    title        string    // Room title
    description  string    // Room description
    creationTime time.Time // When the room was created
    isActive     bool      // Whether broadcasting is active
}
```

The `roomState` structure represents a virtual room:
- `broadcaster`: Pointer to the broadcaster's connection state (only one per room)
- `viewers`: List of viewer connection states
- `trackLocals`: Map of media tracks being relayed in this room
- `title`, `description`: Metadata for the room
- `creationTime`: When the room was created
- `isActive`: Whether broadcasting is currently active in this room

### websocketMessage

```go
type websocketMessage struct {
    Event string `json:"event"`
    Data  string `json:"data"`
    Room  string `json:"room,omitempty"`  // Room ID for room operations
    Role  string `json:"role,omitempty"`  // "broadcaster" or "viewer"
    Title string `json:"title,omitempty"` // Room title (for room creation)
    Desc  string `json:"desc,omitempty"`  // Room description (for room creation)
}
```

The `websocketMessage` structure is used for all WebSocket communication:
- `Event`: The message type (e.g., "offer", "answer", "candidate", "room_joined")
- `Data`: The main payload of the message (often JSON-encoded WebRTC data)
- `Room`: Room identifier for room operations
- `Role`: Whether the user is a "broadcaster" or "viewer"
- `Title`, `Desc`: Room metadata for room creation/joining

### peerConnectionState

```go
type peerConnectionState struct {
    peerConnection *webrtc.PeerConnection
    websocket      *threadSafeWriter
}
```

The `peerConnectionState` tracks the state for each connected peer:
- `peerConnection`: WebRTC peer connection
- `websocket`: Thread-safe WebSocket connection for signaling

### RoomInfo

```go
type RoomInfo struct {
    ID          string `json:"id"`
    Title       string `json:"title"`
    Description string `json:"description"`
    IsActive    bool   `json:"isActive"`
    ViewerCount int    `json:"viewerCount"`
    CreatedAt   string `json:"createdAt"`
}
```

The `RoomInfo` structure represents room metadata for the API:
- `ID`: Unique room identifier
- `Title`, `Description`: Room metadata
- `IsActive`: Whether broadcasting is active
- `ViewerCount`: Number of viewers
- `CreatedAt`: Timestamp when the room was created

## Main Function and Server Setup

The `main()` function initializes and starts the server:

```go
func main() {
    // Parse the flags passed to program
    flag.Parse()

    fmt.Println("Starting SFU at port ", *addr)

    // Read index.html from disk
    indexHTML, err := os.ReadFile("index.html")
    if err != nil {
        panic(err)
    }
    indexTemplate = template.Must(template.New("").Parse(string(indexHTML)))

    // API endpoint for room listing
    http.HandleFunc("/api/rooms", roomsListHandler)

    // websocket handler with room support
    http.HandleFunc("/websocket", websocketHandler)

    // index.html handler
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        if err = indexTemplate.Execute(w, ""); err != nil {
            log.Errorf("Failed to parse index template: %v", err)
        }
    })

    // request a keyframe every 3 seconds for all rooms
    go func() {
        for range time.NewTicker(time.Second * 3).C {
            dispatchKeyFrameAllRooms()
        }
    }()

    // Create a server with graceful shutdown
    server := &http.Server{
        Addr:    *addr,
        Handler: nil, // Use default mux
    }

    // Set up graceful shutdown
    go func() {
        // Listen for interrupt signal
        sigint := make(chan os.Signal, 1)
        signal.Notify(sigint, syscall.SIGINT, syscall.SIGTERM)
        <-sigint

        log.Infof("Received interrupt signal, shutting down server...")
        ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
        defer cancel()

        if err := server.Shutdown(ctx); err != nil {
            log.Errorf("Server shutdown error: %v", err)
        }
    }()

    // Start HTTP server
    log.Infof("Starting SFU server on %s", *addr)
    if err = server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
        log.Errorf("Failed to start http server: %v", err)
    }
}
```

Key steps:
1. Parse command-line flags (like the server address)
2. Read and parse the index.html template for the web interface
3. Set up HTTP routes:
   - `/api/rooms` - API for listing available rooms
   - `/websocket` - WebSocket endpoint for WebRTC signaling
   - `/` - Serves the main web interface
4. Start a goroutine to request keyframes every 3 seconds to ensure video quality
5. Set up a graceful shutdown handler that catches interrupt signals
6. Start the HTTP server on the configured address

## Room Management

The server manages virtual rooms where broadcasting occurs:

### Room Listing

The `roomsListHandler` function provides an API for listing available rooms:

```go
func roomsListHandler(w http.ResponseWriter, r *http.Request) {
    // ... CORS headers ...

    listLock.RLock()
    defer listLock.RUnlock()

    // Get all room details
    roomList := make([]RoomInfo, 0, len(rooms))
    for id, room := range rooms {
        // Only include rooms that have a broadcaster
        if room.broadcaster != nil {
            roomInfo := RoomInfo{
                ID:          id,
                Title:       room.title,
                Description: room.description,
                IsActive:    room.isActive && room.broadcaster != nil,
                ViewerCount: len(room.viewers),
                CreatedAt:   room.creationTime.Format(time.RFC3339),
            }

            // If title is empty, use room ID as title
            if roomInfo.Title == "" {
                roomInfo.Title = id
            }

            roomList = append(roomList, roomInfo)
        }
    }

    // If no rooms exist, add a default room
    if len(roomList) == 0 {
        roomList = append(roomList, RoomInfo{
            ID:          "default",
            Title:       "Default Room",
            Description: "Default broadcast room",
            IsActive:    false,
            ViewerCount: 0,
            CreatedAt:   time.Now().Format(time.RFC3339),
        })
    }

    // Return room list as JSON
    json.NewEncoder(w).Encode(map[string]interface{}{
        "rooms": roomList,
    })
}
```

This function:
1. Sets CORS headers to allow cross-origin requests
2. Locks the rooms list for reading to prevent concurrent modifications
3. Builds a list of rooms with metadata like title, description, and viewer count
4. If no rooms exist, creates a default room entry
5. Returns the room list as JSON

### Room Creation

Rooms can be created dynamically when a broadcaster joins:

```go
// Inside websocketHandler's message loop
if message.Event == "create_room" && message.Room != "" {
    if role != "broadcaster" {
        // Only broadcasters can create rooms
        if err = c.WriteJSON(&websocketMessage{
            Event: "error",
            Data:  "Only broadcasters can create rooms",
        }); err != nil {
            log.Errorf("Failed to send error message: %v", err)
        }
        continue
    }

    newRoomID := message.Room
    title := message.Title
    description := message.Desc

    if title == "" {
        title = newRoomID
    }

    if description == "" {
        description = "Live broadcast"
    }

    // Remove broadcaster from current room
    listLock.Lock()
    if room, ok := rooms[roomID]; ok && room.broadcaster != nil &&
        room.broadcaster.websocket == c {
        room.broadcaster = nil
        room.isActive = false

        // Clean up old room if broadcaster is leaving it
        oldRoomID := roomID
        go func() {
            // Wait a short time to ensure all resources are properly released
            time.Sleep(2 * time.Second)
            cleanupRoom(oldRoomID)
        }()
    }

    // Create or update new room
    if _, ok := rooms[newRoomID]; !ok {
        rooms[newRoomID] = &roomState{
            broadcaster:  &peerState,
            viewers:      []peerConnectionState{},
            trackLocals:  map[string]*webrtc.TrackLocalStaticRTP{},
            title:        title,
            description:  description,
            creationTime: time.Now(),
            isActive:     false,
        }
    } else {
        // Update existing room
        rooms[newRoomID].broadcaster = &peerState
        rooms[newRoomID].title = title
        rooms[newRoomID].description = description
        // Keep existing viewers
    }
    listLock.Unlock()

    roomID = newRoomID

    // Inform client they've created a new room
    if err = c.WriteJSON(&websocketMessage{
        Event: "room_created",
        Data:  roomID,
        Room:  roomID,
        Title: title,
        Desc:  description,
    }); err != nil {
        log.Errorf("Failed to send room_created message: %v", err)
    }
}
```

This code:
1. Verifies the client is a broadcaster (only broadcasters can create rooms)
2. Extracts room metadata from the message
3. Removes the broadcaster from their current room if applicable
4. Creates a new room or updates an existing one with the broadcaster
5. Sends confirmation back to the client

### Room Cleanup

The `cleanupRoom` function removes rooms when they're no longer needed:

```go
func cleanupRoom(roomID string) {
    listLock.Lock()
    defer listLock.Unlock()

    // Make sure the room exists before removing it
    if room, ok := rooms[roomID]; ok {
        // Force remove the room if broadcaster has left
        if room.broadcaster == nil {
            log.Infof("Removing room: %s", roomID)
            delete(rooms, roomID)
        }
    }
}
```

This function:
1. Locks the rooms list for exclusive access
2. Checks if the room exists and has no broadcaster
3. Removes the room from the global rooms map

## Track Management

The server manages media tracks for relaying from broadcaster to viewers:

### Adding Tracks

The `addTrack` function creates a new trackLocal for relaying media:

```go
func addTrack(roomID string, t *webrtc.TrackRemote) *webrtc.TrackLocalStaticRTP {
    listLock.Lock()
    defer func() {
        listLock.Unlock()
        signalViewersInRoom(roomID)
    }()

    // Make sure the room exists
    if _, ok := rooms[roomID]; !ok {
        rooms[roomID] = &roomState{
            broadcaster:  nil,
            viewers:      []peerConnectionState{},
            trackLocals:  map[string]*webrtc.TrackLocalStaticRTP{},
            title:        roomID,
            description:  "Live broadcast",
            creationTime: time.Now(),
            isActive:     true,
        }
    }

    // Create a new TrackLocal with the same codec as our incoming
    trackLocal, err := webrtc.NewTrackLocalStaticRTP(t.Codec().RTPCodecCapability, t.ID(), t.StreamID())
    if err != nil {
        panic(err)
    }

    // Store the track and mark room as active
    rooms[roomID].trackLocals[t.ID()] = trackLocal
    rooms[roomID].isActive = true

    return trackLocal
}
```

This function:
1. Locks the rooms list for exclusive access
2. Ensures the room exists, creating it if necessary
3. Creates a new local track with the same codec as the incoming track
4. Stores the track in the room's trackLocals map
5. Marks the room as active
6. Signals viewers in the room to update their connections
7. Returns the newly created track

### Removing Tracks

The `removeTrack` function handles cleanup when tracks are removed:

```go
func removeTrack(roomID string, t *webrtc.TrackLocalStaticRTP) {
    listLock.Lock()
    defer func() {
        listLock.Unlock()
        signalViewersInRoom(roomID)
    }()

    // Make sure the room exists
    if room, ok := rooms[roomID]; ok {
        delete(room.trackLocals, t.ID())

        // If no tracks left, mark room as inactive
        if len(room.trackLocals) == 0 {
            room.isActive = false
        }
    }
}
```

This function:
1. Locks the rooms list for exclusive access
2. Removes the track from the room's trackLocals map
3. If no tracks remain, marks the room as inactive
4. Signals viewers in the room to update their connections

## WebSocket Connection Handling

The `websocketHandler` function is the core of the server, handling all WebSocket connections:

```go
func websocketHandler(w http.ResponseWriter, r *http.Request) {
    // Default room ID and role
    roomID := "default"
    role := "viewer" // Default role is viewer

    // Get room ID from query parameter if provided
    if r.URL.Query().Get("room") != "" {
        roomID = r.URL.Query().Get("room")
    }

    // Get role from query parameter if provided
    if r.URL.Query().Get("role") != "" {
        role = r.URL.Query().Get("role")
        if role != "broadcaster" && role != "viewer" {
            role = "viewer" // Default to viewer for invalid roles
        }
    }

    // Upgrade HTTP request to Websocket
    unsafeConn, err := upgrader.Upgrade(w, r, nil)
    if err != nil {
        log.Errorf("Failed to upgrade HTTP to Websocket: %v", err)
        return
    }

    c := &threadSafeWriter{unsafeConn, sync.Mutex{}}
    
    // When this frame returns close the Websocket
    defer c.Close() //nolint

    // Create new PeerConnection
    peerConnection, err := webrtc.NewPeerConnection(webrtc.Configuration{})
    if err != nil {
        log.Errorf("Failed to creates a PeerConnection: %v", err)
        return
    }

    // When this frame returns close the PeerConnection
    defer peerConnection.Close() //nolint

    // ... setup transceivers and event handlers ...

    // Main message handling loop
    message := &websocketMessage{}
    for {
        _, raw, err := c.ReadMessage()
        if err != nil {
            log.Errorf("Failed to read message: %v", err)
            return
        }

        log.Infof("Got message from %s in room %s: %s", role, roomID, raw)

        if err := json.Unmarshal(raw, &message); err != nil {
            log.Errorf("Failed to unmarshal json to message: %v", err)
            return
        }

        // Handle different message types:
        // - create_room
        // - join_room
        // - broadcast_state
        // - candidate
        // - answer
        // - offer
        // ... and more ...
    }
}
```

This function:
1. Extracts room ID and role from query parameters
2. Upgrades the HTTP request to a WebSocket connection
3. Creates a new WebRTC PeerConnection for this client
4. Sets up appropriate transceivers based on the client's role
5. Registers the client in the appropriate room
6. Sets up handlers for WebRTC events
7. Enters a message loop to process incoming WebSocket messages

## WebRTC Signaling

The server implements the complete WebRTC signaling protocol:

### Handling SDP Offers

```go
case "offer":
    // Viewers should not be sending offers
    if role == "viewer" {
        log.Errorf("Received unexpected offer from viewer in room %s", roomID)
        continue
    }

    offer := webrtc.SessionDescription{}
    if err := json.Unmarshal([]byte(message.Data), &offer); err != nil {
        log.Errorf("Failed to unmarshal json to offer: %v", err)
        return
    }

    log.Infof("Got offer from broadcaster in room %s", roomID)

    if err := peerConnection.SetRemoteDescription(offer); err != nil {
        log.Errorf("Failed to set remote description: %v", err)
        return
    }

    // Create answer
    answer, err := peerConnection.CreateAnswer(nil)
    if err != nil {
        log.Errorf("Failed to create answer: %v", err)
        return
    }

    if err = peerConnection.SetLocalDescription(answer); err != nil {
        log.Errorf("Failed to set local description: %v", err)
        return
    }

    // Send answer
    answerString, err := json.Marshal(answer)
    if err != nil {
        log.Errorf("Failed to marshal answer: %v", err)
        return
    }

    if err = c.WriteJSON(&websocketMessage{
        Event: "answer",
        Data:  string(answerString),
        Room:  roomID,
        Role:  role,
    }); err != nil {
        log.Errorf("Failed to send answer: %v", err)
        return
    }
```

This code:
1. Verifies the offer is from a broadcaster (viewers shouldn't send offers)
2. Unmarshals the SDP offer
3. Sets it as the remote description
4. Creates an answer
5. Sets the answer as the local description
6. Sends the answer back to the client

### Handling SDP Answers

```go
case "answer":
    answer := webrtc.SessionDescription{}
    if err := json.Unmarshal([]byte(message.Data), &answer); err != nil {
        log.Errorf("Failed to unmarshal json to answer: %v", err)
        return
    }

    log.Infof("Got answer from %s in room %s", role, roomID)

    if err := peerConnection.SetRemoteDescription(answer); err != nil {
        log.Errorf("Failed to set remote description: %v", err)
        return
    }
```

This code:
1. Unmarshals the SDP answer
2. Sets it as the remote description on the peer connection

### Handling ICE Candidates

```go
case "candidate":
    candidate := webrtc.ICECandidateInit{}
    if err := json.Unmarshal([]byte(message.Data), &candidate); err != nil {
        log.Errorf("Failed to unmarshal json to candidate: %v", err)
        return
    }

    log.Infof("Got candidate from %s in room %s", role, roomID)

    if err := peerConnection.AddICECandidate(candidate); err != nil {
        log.Errorf("Failed to add ICE candidate: %v", err)
        return
    }
```

This code:
1. Unmarshals the ICE candidate
2. Adds it to the peer connection

## Media Relay

The core of the SFU functionality is relaying media from broadcasters to viewers:

```go
// Handle incoming tracks (mainly from broadcaster)
peerConnection.OnTrack(func(t *webrtc.TrackRemote, _ *webrtc.RTPReceiver) {
    log.Infof("Got remote track from %s in room %s: Kind=%s, ID=%s",
        role, roomID, t.Kind(), t.ID())

    // Only process tracks from broadcaster
    if role != "broadcaster" {
        log.Infof("Ignoring track from viewer in room %s", roomID)
        return
    }

    // Create a track to fan out broadcaster's media to all viewers
    trackLocal := addTrack(roomID, t)
    defer removeTrack(roomID, trackLocal)

    // Mark room as active now that we're receiving media
    listLock.Lock()
    if room, ok := rooms[roomID]; ok {
        room.isActive = true
    }
    listLock.Unlock()

    buf := make([]byte, 1500)
    rtpPkt := &rtp.Packet{}

    for {
        i, _, err := t.Read(buf)
        if err != nil {
            log.Errorf("Error reading from track: %v", err)
            return
        }

        if err = rtpPkt.Unmarshal(buf[:i]); err != nil {
            log.Errorf("Failed to unmarshal incoming RTP packet: %v", err)
            continue
        }

        rtpPkt.Extension = false
        rtpPkt.Extensions = nil

        if err = trackLocal.WriteRTP(rtpPkt); err != nil {
            log.Errorf("Error writing to track: %v", err)
            return
        }
    }
})
```

This function:
1. Only processes tracks from broadcasters
2. Creates a local track for relaying to viewers
3. Marks the room as active
4. Enters a loop to read incoming RTP packets
5. Cleans up RTP packets by removing extensions
6. Writes the packets to the local track, which automatically distributes them to all viewers

## Connection Management

The server needs to manage peer connections for both broadcasters and viewers:

### Signaling Viewers

The `signalViewersInRoom` function updates viewers when tracks change:

```go
func signalViewersInRoom(roomID string) {
    listLock.Lock()
    defer func() {
        listLock.Unlock()
        dispatchKeyFrame(roomID)
    }()

    // ... room existence check ...

    attemptSync := func() (tryAgain bool) {
        // Iterate through all viewers
        for i := range room.viewers {
            if room.viewers[i].peerConnection.ConnectionState() == webrtc.PeerConnectionStateClosed {
                // Remove closed connections
                room.viewers = append(room.viewers[:i], room.viewers[i+1:]...)
                return true // We modified the slice, start from the beginning
            }

            // map of sender we already are sending, so we don't double send
            existingSenders := map[string]bool{}

            // ... remove tracks no longer available ...

            // Add all tracks we aren't sending yet to the viewer's PeerConnection
            for trackID := range room.trackLocals {
                if _, ok := existingSenders[trackID]; !ok {
                    if _, err := room.viewers[i].peerConnection.AddTrack(room.trackLocals[trackID]); err != nil {
                        return true
                    }
                }
            }

            // Create offer for this viewer
            offer, err := room.viewers[i].peerConnection.CreateOffer(nil)
            // ... set local description and send offer to viewer ...
        }

        return
    }

    // Retry sync up to 25 times
    for syncAttempt := 0; ; syncAttempt++ {
        if syncAttempt == 25 {
            // Release the lock and try again later
            go func() {
                time.Sleep(time.Second * 3)
                signalViewersInRoom(roomID)
            }()
            return
        }

        if !attemptSync() {
            break
        }
    }
}
```

This complex function:
1. Locks the rooms list for exclusive access
2. For each viewer in the room:
   - Removes closed connections
   - Identifies which tracks are already being sent
   - Removes tracks that are no longer available
   - Adds new tracks that aren't being sent yet
   - Creates a new offer with the updated tracks
   - Sends the offer to the viewer
3. Retries up to 25 times if modifications are needed
4. Schedules a keyframe request after updating all viewers

### Keyframe Requests

The `dispatchKeyFrame` function requests keyframes to ensure video quality:

```go
func dispatchKeyFrame(roomID string) {
    listLock.Lock()
    defer listLock.Unlock()

    // Make sure the room exists
    room, ok := rooms[roomID]
    if !ok {
        return
    }

    // Request keyframe from broadcaster
    if room.broadcaster != nil && room.broadcaster.peerConnection.ConnectionState() != webrtc.PeerConnectionStateClosed {
        for _, receiver := range room.broadcaster.peerConnection.GetReceivers() {
            if receiver.Track() == nil {
                continue
            }

            _ = room.broadcaster.peerConnection.WriteRTCP([]rtcp.Packet{
                &rtcp.PictureLossIndication{
                    MediaSSRC: uint32(receiver.Track().SSRC()),
                },
            })
        }
    }

    // Send keyframe request to all viewers as well (in case they're sending media)
    for i := range room.viewers {
        // ... similar code for viewers ...
    }
}
```

This function:
1. Locks the rooms list for reading
2. Sends Picture Loss Indication (PLI) RTCP packets to the broadcaster
3. This tells the broadcaster to send a keyframe, which helps viewers recover from packet loss
4. Also sends PLI to viewers in case they're sending media

## Utility Functions

### Thread-Safe WebSocket Writer

```go
type threadSafeWriter struct {
    *websocket.Conn
    sync.Mutex
}

func (t *threadSafeWriter) WriteJSON(v interface{}) error {
    t.Lock()
    defer t.Unlock()

    return t.Conn.WriteJSON(v)
}
```

This wrapper:
1. Makes the WebSocket's WriteJSON method thread-safe using a mutex
2. Ensures multiple goroutines can safely write to the same WebSocket without conflicts

## Real-World Examples

### Example 1: Broadcasting a Video Stream

1. A broadcaster connects to the server via the WebSocket endpoint with `?role=broadcaster&room=myRoom`
2. The server:
   - Creates a new room or adds the broadcaster to an existing room
   - Sets up a WebRTC peer connection with receive-only transceivers
3. The broadcaster sends a WebRTC offer to initiate the connection
4. The server responds with an answer to complete the connection
5. Once connected, the broadcaster starts sending audio and video tracks
6. The server receives these tracks and creates local tracks for relaying to viewers
7. The server marks the room as active and makes it visible in the room list API

### Example 2: Viewing a Stream

1. A viewer connects to the server via the WebSocket endpoint with `?role=viewer&room=myRoom`
2. The server:
   - Adds the viewer to the specified room
   - Creates a WebRTC peer connection
   - Adds all available tracks from the broadcaster to this connection
   - Creates and sends an offer to the viewer
3. The viewer responds with an answer to complete the connection
4. Once connected, the viewer starts receiving media from the broadcaster via the server
5. The server periodically requests keyframes to ensure video quality
6. If the broadcaster adds or removes tracks, the server signals all viewers to update their connections

### Example 3: Room Management

1. A user accesses the `/api/rooms` endpoint to get a list of available rooms
2. The server returns JSON with room details including:
   - Room ID, title, and description
   - Whether broadcasting is active
   - Number of viewers
   - When the room was created
3. The user can then choose which room to join as either a broadcaster or viewer
4. If a broadcaster disconnects, the server:
   - Marks the room as inactive
   - Notifies all viewers
   - Eventually cleans up the room if no new broadcaster joins

## Go Syntax Highlights

For those new to Go, here are explanations of some Go-specific syntax seen in this code:

1. **Goroutines**: Functions prefixed with `go` run concurrently:
   ```go
   go func() {
       for range time.NewTicker(time.Second * 3).C {
           dispatchKeyFrameAllRooms()
       }
   }()
   ```
   This creates a background goroutine that runs the ticker loop.

2. **Defer**: The `defer` statement schedules a function call for when the surrounding function returns:
   ```go
   listLock.Lock()
   defer listLock.Unlock()
   ```
   This ensures the lock is always released, even if the function returns early due to an error.

3. **Anonymous Functions**: Go supports function literals:
   ```go
   peerConnection.OnTrack(func(t *webrtc.TrackRemote, _ *webrtc.RTPReceiver) {
       // ... handle track ...
   })
   ```
   These are commonly used for callbacks and event handlers.

4. **Channels**: Go's channels provide synchronized communication:
   ```go
   sigint := make(chan os.Signal, 1)
   signal.Notify(sigint, syscall.SIGINT, syscall.SIGTERM)
   <-sigint  // Wait for signal
   ```
   Here, a channel is used to wait for an interrupt signal.

5. **Struct Tags**: Metadata on struct fields used for serialization:
   ```go
   type websocketMessage struct {
       Event string `json:"event"`
       Data  string `json:"data"`
   }
   ```
   The `json:"event"` tags tell the JSON encoder/decoder which field names to use.

6. **Multiple Return Values**: Go functions commonly return both a value and an error:
   ```go
   answer, err := peerConnection.CreateAnswer(nil)
   if err != nil {
       log.Errorf("Failed to create answer: %v", err)
       return
   }
   ```
   This pattern makes error handling explicit.

7. **Type Embedding**: Go uses composition over inheritance:
   ```go
   type threadSafeWriter struct {
       *websocket.Conn
       sync.Mutex
   }
   ```
   This embeds both a WebSocket connection and a mutex in the new type.

## Conclusion

This WebRTC SFU server demonstrates how to implement a scalable broadcasting system in Go. It showcases:

- WebRTC for real-time audio/video transmission
- WebSockets for signaling
- Room-based organization for broadcasts
- Efficient media relay from one broadcaster to many viewers
- Connection management and cleanup
- API for room discovery
- Graceful server handling

The SFU architecture is highly efficient for broadcasting scenarios where one sender streams to multiple receivers, making it suitable for applications like live streaming, webinars, or online classrooms.
