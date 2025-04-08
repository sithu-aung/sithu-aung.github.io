# Real-Time Bidding Implementation Guide

This guide outlines three approaches for implementing real-time bidding functionality in an auction system using Vue3 (frontend) and Yii2 (backend).

## 1. WebSockets with Ratchet/Swoole

WebSockets provide a persistent, bidirectional connection between clients and the server, enabling real-time data transfer with minimal latency.

### Implementation steps:

1. **Install WebSocket Server:**
   ```bash
   composer require cboden/ratchet
   ```
   
2. **Create WebSocket Server:**
   ```php
   // In a file like websocket-server.php
   <?php
   use Ratchet\Server\IoServer;
   use Ratchet\Http\HttpServer;
   use Ratchet\WebSocket\WsServer;
   
   require __DIR__ . '/vendor/autoload.php';
   
   class BiddingServer implements MessageComponentInterface {
       protected $clients;
       protected $auctions = [];
       
       public function __construct() {
           $this->clients = new \SplObjectStorage;
       }
       
       public function onOpen(ConnectionInterface $conn) {
           $this->clients->attach($conn);
       }
       
       public function onMessage(ConnectionInterface $from, $msg) {
           $data = json_decode($msg);
           if ($data->type === 'subscribe') {
               // Subscribe to auction updates
               $this->auctions[$data->auction_id][] = $from;
           }
       }
       
       public function onClose(ConnectionInterface $conn) {
           $this->clients->detach($conn);
       }
       
       public function onError(ConnectionInterface $conn, \Exception $e) {
           $conn->close();
       }
       
       // Method to broadcast bid updates
       public function broadcastBid($auctionId, $bidData) {
           if (isset($this->auctions[$auctionId])) {
               foreach ($this->auctions[$auctionId] as $client) {
                   $client->send(json_encode($bidData));
               }
           }
       }
   }
   
   $server = IoServer::factory(
       new HttpServer(
           new WsServer(
               new BiddingServer()
           )
       ),
       8080
   );
   
   $server->run();
   ```

3. **Modify BiddingController to notify WebSocket server:**
   ```php
   public function actionCreate()
   {
       // Existing bid creation logic...
       
       if ($bidding->save()) {
           // Broadcast to WebSocket server
           $this->notifyWebSocketServer($auctionModel->id, [
               'type' => 'new_bid',
               'auction_id' => $auctionModel->id,
               'current_bid' => $auctionModel->current_bid,
               'asking_price' => $auctionModel->asking_price,
               'bidder' => $this->user ? $this->user->username : 'Hall Bidder'
           ]);
           
           return ['status' => 'ok', 'data' => $bidding];
       }
   }
   
   protected function notifyWebSocketServer($auctionId, $data)
   {
       // Option 1: Using Redis pub/sub
       $redis = new \Redis();
       $redis->connect('127.0.0.1', 6379);
       $redis->publish('auction_updates', json_encode([
           'auction_id' => $auctionId,
           'data' => $data
       ]));
       
       // Option 2: Direct HTTP call to WebSocket server's admin API
       // $client = new \GuzzleHttp\Client();
       // $client->post('http://localhost:8081/notify', [
       //     'json' => [
       //         'auction_id' => $auctionId,
       //         'data' => $data
       //     ]
       // ]);
   }
   ```

4. **Vue3 client implementation:**
   ```javascript
   // In your Vue component
   import { ref, onMounted, onUnmounted } from 'vue'
   
   export default {
     props: ['auctionId'],
     setup(props) {
       const currentBid = ref(0)
       const askingPrice = ref(0)
       const lastBidder = ref('')
       let socket = null
       
       const connectWebSocket = () => {
         socket = new WebSocket('ws://your-server:8080')
         
         socket.onopen = () => {
           // Subscribe to auction updates
           socket.send(JSON.stringify({
             type: 'subscribe',
             auction_id: props.auctionId
           }))
         }
         
         socket.onmessage = (event) => {
           const data = JSON.parse(event.data)
           if (data.type === 'new_bid') {
             currentBid.value = data.current_bid
             askingPrice.value = data.asking_price
             lastBidder.value = data.bidder
           }
         }
         
         socket.onerror = (error) => {
           console.error('WebSocket error:', error)
         }
         
         socket.onclose = () => {
           setTimeout(connectWebSocket, 5000) // Reconnect on close
         }
       }
       
       onMounted(() => {
         connectWebSocket()
       })
       
       onUnmounted(() => {
         if (socket) {
           socket.close()
         }
       })
       
       return {
         currentBid,
         askingPrice,
         lastBidder
       }
     }
   }
   ```

5. **Run WebSocket server as a daemon:**
   Create a systemd service or use Supervisor to keep the WebSocket server running.

## 2. Server-Sent Events (SSE)

SSE is a one-way communication channel from server to client that allows the server to push updates to the client.

### Implementation steps:

1. **Create SSE Controller in Yii2:**
   ```php
   <?php
   namespace app\controllers;
   
   use Yii;
   use yii\web\Controller;
   
   class SseController extends Controller
   {
       public function actionStream($auction_id)
       {
           // Disable output buffering
           while (ob_get_level()) ob_end_clean();
           
           // Set headers for SSE
           Yii::$app->response->headers->set('Content-Type', 'text/event-stream');
           Yii::$app->response->headers->set('Cache-Control', 'no-cache');
           Yii::$app->response->headers->set('Connection', 'keep-alive');
           
           // Send initial headers
           Yii::$app->response->sendHeaders();
           
           // Create a unique client ID
           $client_id = uniqid();
           
           // Register this client in Redis
           $redis = new \Redis();
           $redis->connect('127.0.0.1', 6379);
           $redis->hSet('sse_clients', $client_id, $auction_id);
           
           // Subscribe to auction channel
           $redis->subscribe(['auction_' . $auction_id], function($redis, $channel, $message) {
               echo "event: bid_update\n";
               echo "data: " . $message . "\n\n";
               flush();
           });
           
           // Remove client on disconnect
           $redis->hDel('sse_clients', $client_id);
           
           return '';
       }
   }
   ```

2. **Modify BiddingController to publish updates:**
   ```php
   protected function notifySSEClients($auctionId, $data)
   {
       $redis = new \Redis();
       $redis->connect('127.0.0.1', 6379);
       $redis->publish('auction_' . $auctionId, json_encode($data));
   }
   
   public function actionCreate()
   {
       // Existing bid creation logic...
       
       if ($bidding->save()) {
           // Notify SSE clients
           $this->notifySSEClients($auctionModel->id, [
               'auction_id' => $auctionModel->id,
               'current_bid' => $auctionModel->current_bid,
               'asking_price' => $auctionModel->asking_price,
               'bidder' => $this->user ? $this->user->username : 'Hall Bidder'
           ]);
           
           return ['status' => 'ok', 'data' => $bidding];
       }
   }
   ```

3. **Vue3 client implementation:**
   ```javascript
   import { ref, onMounted, onUnmounted } from 'vue'
   
   export default {
     props: ['auctionId'],
     setup(props) {
       const currentBid = ref(0)
       const askingPrice = ref(0)
       const lastBidder = ref('')
       let eventSource = null
       
       const connectSSE = () => {
         eventSource = new EventSource(`/sse/stream?auction_id=${props.auctionId}`)
         
         eventSource.addEventListener('bid_update', (event) => {
           const data = JSON.parse(event.data)
           currentBid.value = data.current_bid
           askingPrice.value = data.asking_price
           lastBidder.value = data.bidder
         })
         
         eventSource.onerror = () => {
           eventSource.close()
           setTimeout(connectSSE, 5000) // Reconnect on error
         }
       }
       
       onMounted(() => {
         connectSSE()
       })
       
       onUnmounted(() => {
         if (eventSource) {
           eventSource.close()
         }
       })
       
       return {
         currentBid,
         askingPrice,
         lastBidder
       }
     }
   }
   ```

## 3. Redis Pub/Sub

Redis Pub/Sub leverages Redis as a message broker between your application components.

### Implementation steps:

1. **Install Redis PHP extension and predis:**
   ```bash
   pecl install redis
   composer require predis/predis
   ```

2. **Create Redis service class:**
   ```php
   <?php
   namespace app\components;
   
   use yii\base\Component;
   
   class RedisService extends Component
   {
       public $redis;
       
       public function init()
       {
           parent::init();
           $this->redis = new \Redis();
           $this->redis->connect('127.0.0.1', 6379);
       }
       
       public function publish($channel, $message)
       {
           return $this->redis->publish($channel, json_encode($message));
       }
       
       public function subscribe($channels, $callback)
       {
           return $this->redis->subscribe($channels, $callback);
       }
   }
   ```

3. **Configure Redis in Yii2:**
   ```php
   // In config/web.php
   'components' => [
       'redis' => [
           'class' => 'app\components\RedisService',
       ],
   ]
   ```

4. **Create WebSocket server that subscribes to Redis:**
   ```php
   <?php
   // websocket-redis-bridge.php
   use Ratchet\Server\IoServer;
   use Ratchet\Http\HttpServer;
   use Ratchet\WebSocket\WsServer;
   
   require __DIR__ . '/vendor/autoload.php';
   
   class RedisBridge implements MessageComponentInterface
   {
       protected $clients;
       protected $auctions = [];
       protected $redis;
       
       public function __construct()
       {
           $this->clients = new \SplObjectStorage;
           $this->setupRedis();
       }
       
       protected function setupRedis()
       {
           $this->redis = new \Redis();
           $this->redis->connect('127.0.0.1', 6379);
           
           // Start a Redis client in subscription mode
           $redisSubscriber = new \Redis();
           $redisSubscriber->connect('127.0.0.1', 6379);
           
           // Subscribe to the auction channel
           // This needs to be in a separate process/thread
           $redisSubscriber->psubscribe(['auction_*'], function($redis, $pattern, $channel, $message) {
               $auctionId = str_replace('auction_', '', $channel);
               $this->broadcastMessage($auctionId, $message);
           });
       }
       
       public function onOpen(ConnectionInterface $conn)
       {
           $this->clients->attach($conn);
       }
       
       public function onMessage(ConnectionInterface $from, $msg)
       {
           $data = json_decode($msg);
           if ($data->type === 'subscribe') {
               // Add client to auction subscribers
               $this->auctions[$data->auction_id][] = $from;
           }
       }
       
       public function broadcastMessage($auctionId, $message)
       {
           if (isset($this->auctions[$auctionId])) {
               foreach ($this->auctions[$auctionId] as $client) {
                   $client->send($message);
               }
           }
       }
       
       public function onClose(ConnectionInterface $conn)
       {
           $this->clients->detach($conn);
       }
       
       public function onError(ConnectionInterface $conn, \Exception $e)
       {
           $conn->close();
       }
   }
   
   $server = IoServer::factory(
       new HttpServer(
           new WsServer(
               new RedisBridge()
           )
       ),
       8080
   );
   
   $server->run();
   ```

5. **Modify BiddingController to publish to Redis:**
   ```php
   public function actionCreate()
   {
       // Existing bid creation logic...
       
       if ($bidding->save()) {
           // Publish to Redis
           Yii::$app->redis->publish('auction_' . $auctionModel->id, [
               'type' => 'new_bid',
               'auction_id' => $auctionModel->id,
               'current_bid' => $auctionModel->current_bid,
               'asking_price' => $auctionModel->asking_price,
               'bidder' => $this->user ? $this->user->username : 'Hall Bidder'
           ]);
           
           return ['status' => 'ok', 'data' => $bidding];
       }
   }
   ```

6. **Vue3 client (same as WebSocket example):**
   ```javascript
   import { ref, onMounted, onUnmounted } from 'vue'
   
   export default {
     props: ['auctionId'],
     setup(props) {
       const currentBid = ref(0)
       const askingPrice = ref(0)
       const lastBidder = ref('')
       let socket = null
       
       const connectWebSocket = () => {
         socket = new WebSocket('ws://your-server:8080')
         
         socket.onopen = () => {
           // Subscribe to auction updates
           socket.send(JSON.stringify({
             type: 'subscribe',
             auction_id: props.auctionId
           }))
         }
         
         socket.onmessage = (event) => {
           const data = JSON.parse(event.data)
           if (data.type === 'new_bid') {
             currentBid.value = data.current_bid
             askingPrice.value = data.asking_price
             lastBidder.value = data.bidder
           }
         }
         
         socket.onerror = (error) => {
           console.error('WebSocket error:', error)
         }
         
         socket.onclose = () => {
           setTimeout(connectWebSocket, 5000) // Reconnect on close
         }
       }
       
       onMounted(() => {
         connectWebSocket()
       })
       
       onUnmounted(() => {
         if (socket) {
           socket.close()
         }
       })
       
       return {
         currentBid,
         askingPrice,
         lastBidder
       }
     }
   }
   ```

## Key Considerations

1. **Scalability**: 
   - Redis Pub/Sub is easier to scale than direct WebSockets
   - For high-traffic auctions, consider horizontal scaling of WebSocket servers

2. **Deployment**: 
   - WebSockets require special server configuration (separate long-running process)
   - SSE works with standard HTTP servers but may require tweaking timeouts
   - Production setup should include process monitoring (Supervisor, systemd)

3. **Fallback Mechanisms**: 
   - Implement fallback to polling if WebSockets/SSE fail
   - Consider a progressive enhancement approach

4. **State Management**: 
   - Use Redis or another persistent storage to maintain state
   - Ensure new clients get the current state on connection

5. **Error Handling**: 
   - Implement reconnect logic for all approaches
   - Add logging for connection issues

6. **Security Considerations**:
   - Authenticate WebSocket connections
   - Validate data in all directions
   - Consider rate limiting to prevent abuse

7. **Performance Monitoring**:
   - Track WebSocket connection count and message rate
   - Monitor Redis memory usage
   - Set up alerts for connection drops

## Recommendation

For most auction systems, the **Redis Pub/Sub** approach provides the best balance between:
- Real-time performance
- Scalability 
- Implementation complexity
- Reliability

This architecture decouples the bidding logic from the real-time notification system, making it easier to maintain and scale independently.
