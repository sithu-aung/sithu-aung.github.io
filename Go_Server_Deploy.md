# WebRTC SFU Server Deployment Guide - Ubuntu

This guide provides step-by-step instructions for deploying the Go WebRTC SFU server on Ubuntu.

## 1. Install Required Software

```bash
# Update package lists
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y build-essential git curl

# Install Go
wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz
rm go1.22.0.linux-amd64.tar.gz

# Add Go to path
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Verify Go installation
go version
```

## 2. Set Up Project Directory

```bash
# Create project directory
mkdir -p ~/stream_rtc
cd ~/stream_rtc

# Create sfu-ws directory
mkdir -p sfu-ws
```

## 3. Copy Project Files

```bash
# Copy main.go to the sfu-ws directory
# Copy index.html to the sfu-ws directory

# If you're copying from a remote source, you might use:
# scp /path/to/main.go username@your-server:~/stream_rtc/sfu-ws/
# scp /path/to/index.html username@your-server:~/stream_rtc/sfu-ws/
```

## 4. Install Dependencies and Build Application

```bash
cd ~/stream_rtc/sfu-ws

# Initialize Go module
go mod init stream_rtc/sfu-ws

# Install required packages
go get github.com/gorilla/websocket
go get github.com/pion/logging
go get github.com/pion/rtcp
go get github.com/pion/rtp
go get github.com/pion/webrtc/v4

# Build the application
go build -o sfu-server main.go
```

## 5. Configure Firewall

```bash
# Allow HTTP traffic on port 8082
sudo ufw allow 8082/tcp

# Make sure firewall is enabled
sudo ufw enable
```

## 6. Create Systemd Service

```bash
# Create systemd service file
sudo tee /etc/systemd/system/sfu-server.service > /dev/null << 'EOF'
[Unit]
Description=WebRTC SFU Server
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/stream_rtc/sfu-ws
ExecStart=/home/ubuntu/stream_rtc/sfu-ws/sfu-server
Restart=always
RestartSec=5
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=sfu-server

[Install]
WantedBy=multi-user.target
EOF
```

> **Note**: Replace `ubuntu` with your actual username in the service file if different.

## 7. Start and Enable the Service

```bash
# Reload systemd daemon
sudo systemctl daemon-reload

# Start the service
sudo systemctl start sfu-server

# Enable the service to start on boot
sudo systemctl enable sfu-server

# Check service status
sudo systemctl status sfu-server
```

## 8. Setting Up TLS/HTTPS with Apache (Recommended)

WebRTC works best with HTTPS. Set up Apache as a reverse proxy with Let's Encrypt:

```bash
# Install Apache and Certbot
sudo apt install -y apache2 certbot python3-certbot-apache

# Enable required Apache modules
sudo a2enmod proxy proxy_http proxy_wstunnel ssl

# Configure Apache VirtualHost
sudo tee /etc/apache2/sites-available/sfu-server.conf > /dev/null << 'EOF'
<VirtualHost *:80>
    ServerName your-domain.com
    ServerAdmin webmaster@your-domain.com
    
    ProxyPreserveHost On
    ProxyRequests Off

    <Location />
        ProxyPass http://localhost:8082/
        ProxyPassReverse http://localhost:8082/
    </Location>

    <Location /websocket>
        ProxyPass ws://localhost:8082/websocket
        ProxyPassReverse ws://localhost:8082/websocket
    </Location>

    ErrorLog ${APACHE_LOG_DIR}/sfu-error.log
    CustomLog ${APACHE_LOG_DIR}/sfu-access.log combined
</VirtualHost>
EOF
```

Enable the site and get SSL certificate:

```bash
# Replace your-domain.com with your actual domain
sudo sed -i 's/your-domain.com/your-actual-domain.com/g' /etc/apache2/sites-available/sfu-server.conf

# Enable the site
sudo a2ensite sfu-server.conf
sudo systemctl reload apache2

# Obtain SSL certificate
sudo certbot --apache -d your-actual-domain.com
```

## 9. Monitoring and Logs

```bash
# View logs
sudo journalctl -u sfu-server -f

# View Apache logs
sudo tail -f /var/log/apache2/sfu-error.log
sudo tail -f /var/log/apache2/sfu-access.log

# Monitor system resources
sudo apt install -y htop
htop
```

## 10. Performance Tuning

For production environments, add these to your server:

```bash
# Edit sysctl.conf
sudo tee -a /etc/sysctl.conf > /dev/null << 'EOF'

# Increase UDP buffer sizes
net.core.rmem_max=16777216
net.core.wmem_max=16777216

# Increase max open files
fs.file-max=65535
EOF

# Apply changes
sudo sysctl -p
```

## 11. Testing Your Deployment

1. Open your browser and navigate to `https://your-domain.com`
2. Choose broadcaster or viewer role
3. Test stream functionality

## 12. Scaling Considerations

For high traffic:
- Consider load balancing across multiple servers
- Optimize network settings for UDP traffic
- Monitor memory and CPU usage

## 13. Troubleshooting

Common issues and solutions:

```bash
# Check if the server is running
sudo systemctl status sfu-server

# Restart the server if needed
sudo systemctl restart sfu-server

# Check for network issues
sudo netstat -tulpn | grep 8082

# Check Apache configuration
sudo apachectl configtest

# Restart Apache
sudo systemctl restart apache2

# Verify TLS certificate
sudo certbot certificates
```

## 14. Backup and Maintenance

```bash
# Backup configuration
sudo cp /etc/apache2/sites-available/sfu-server.conf ~/sfu-server.conf.backup
cp -r ~/stream_rtc ~/stream_rtc.backup

# Update system regularly
sudo apt update && sudo apt upgrade -y

# Renew certificates (Let's Encrypt does this automatically, but you can force it)
sudo certbot renew --force-renewal
```
