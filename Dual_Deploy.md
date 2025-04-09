# Full Stack Deployment Guide: Vue Frontend & Backend on Single Ubuntu Server with Apache

## Initial Server Setup

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y nodejs npm apache2 certbot python3-certbot-apache ufw

# Enable required Apache modules
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod rewrite
sudo a2enmod ssl
sudo a2enmod headers

# Configure firewall
sudo ufw allow OpenSSH
sudo ufw allow 'Apache Full'
sudo ufw enable
```

## Domain Setup

1. Purchase domains (e.g., `example.com` for frontend, `api.example.com` for backend)
2. Point both domains to your server's IP address:
   - Create A records in your domain management panel
   - Set both domains to point to your server IP

## Backend Deployment

```bash
# Create backend directory
sudo mkdir -p /var/www/backend

# Set permissions
sudo chown -R ubuntu:ubuntu /var/www/backend

# Clone your backend repository (replace with your repo URL)
git clone https://github.com/yourusername/your-backend-repo.git /var/www/backend

# Navigate to backend directory
cd /var/www/backend

# Install dependencies
npm install

# Create production environment file
cp .env.example .env
nano .env  # Configure your environment variables

# Build project if needed
npm run build

# Setup PM2 for process management
sudo npm install -g pm2

# Start backend with PM2
pm2 start npm --name "backend" -- start
pm2 startup
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save
```

## Frontend Deployment

```bash
# On your local machine, build the Vue project
npm run build

# Create frontend directory on server
sudo mkdir -p /var/www/html/frontend
sudo chown -R ubuntu:ubuntu /var/www/html/frontend

# Upload dist folder to server using SCP
scp -i /path/to/your/key -r dist/* ubuntu@your-server-ip:/var/www/html/frontend/

# Alternative: clone and build on server
cd /var/www/html
git clone https://github.com/yourusername/your-frontend-repo.git frontend
cd frontend
npm install
npm run build
```

## Apache Configuration for Frontend

```bash
# Create Apache configuration for frontend
sudo nano /etc/apache2/sites-available/frontend.conf

# Add this configuration:
<VirtualHost *:80>
    ServerAdmin webmaster@example.com
    ServerName example.com
    ServerAlias www.example.com
    DocumentRoot /var/www/html/frontend
    
    <Directory /var/www/html/frontend>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/frontend_error.log
    CustomLog ${APACHE_LOG_DIR}/frontend_access.log combined
    
    RewriteEngine on
    RewriteCond %{SERVER_NAME} =example.com [OR]
    RewriteCond %{SERVER_NAME} =www.example.com
    RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>

# Enable the site
sudo a2ensite frontend.conf
sudo systemctl reload apache2
```

## Apache Configuration for Backend API

```bash
# Create Apache configuration for backend
sudo nano /etc/apache2/sites-available/backend.conf

# Add this configuration:
<VirtualHost *:80>
    ServerAdmin webmaster@api.example.com
    ServerName api.example.com
    
    ProxyPreserveHost On
    ProxyPass / http://localhost:3000/
    ProxyPassReverse / http://localhost:3000/
    
    ErrorLog ${APACHE_LOG_DIR}/backend_error.log
    CustomLog ${APACHE_LOG_DIR}/backend_access.log combined
    
    RewriteEngine on
    RewriteCond %{SERVER_NAME} =api.example.com
    RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>

# Enable the site
sudo a2ensite backend.conf
sudo systemctl reload apache2
```

## SSL Configuration with Certbot

```bash
# Obtain SSL certificates for both domains
sudo certbot --apache -d example.com -d www.example.com
sudo certbot --apache -d api.example.com

# Test automatic renewal
sudo certbot renew --dry-run
```

## Frontend SPA Route Handling

```bash
# Create .htaccess file for the frontend
sudo nano /var/www/html/frontend/.htaccess

# Add this configuration:
<IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteBase /
  RewriteRule ^index\.html$ - [L]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule . /index.html [L]
</IfModule>

<IfModule mod_headers.c>
  Header set Permissions-Policy "interest-cohort=()"
</IfModule>
```

## Manual SSL Certificate Export (If Needed for Domain Registrar)

If your domain registrar requires SSL certificates:

```bash
# Certificate locations after Certbot
sudo ls -la /etc/letsencrypt/live/example.com/

# Export certificate files
sudo cp /etc/letsencrypt/live/example.com/fullchain.pem ~/fullchain.pem
sudo cp /etc/letsencrypt/live/example.com/privkey.pem ~/privkey.pem
sudo chown ubuntu:ubuntu ~/fullchain.pem ~/privkey.pem

# Download to your local machine
scp -i /path/to/your/key ubuntu@your-server-ip:~/fullchain.pem ./
scp -i /path/to/your/key ubuntu@your-server-ip:~/privkey.pem ./
```

## Deployment Verification

1. Test frontend access: https://example.com
2. Test backend access: https://api.example.com
3. Check logs if issues occur:
   ```bash
   sudo tail -f /var/log/apache2/frontend_error.log
   sudo tail -f /var/log/apache2/backend_error.log
   pm2 logs
   ```

## Quick Redeploy Commands

### Backend Update

```bash
cd /var/www/backend
git pull
npm install
npm run build  # If needed
pm2 restart backend
```

### Frontend Update

```bash
# On local machine
npm run build

# Upload to server
scp -i /path/to/your/key -r dist/* ubuntu@your-server-ip:/var/www/html/frontend/
```
