# Full Stack Deployment Guide: Vue Frontend & Yii 2 Backend on Single Ubuntu Server with Apache

## Initial Server Setup

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install required packages (if not already installed)
sudo apt install -y nodejs npm apache2 certbot python3-certbot-apache ufw php php-cli php-fpm php-pgsql php-zip php-gd php-mbstring php-curl php-xml php-bcmath php-json php-intl composer git postgresql postgresql-contrib
```

## GitHub Personal Access Token Setup

1. Generate a GitHub Personal Access Token:
   - Go to GitHub.com → Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Click "Generate new token" → "Generate new token (classic)"
   - Give it a name (e.g. "Server Deployment")
   - Select scopes: at minimum, check "repo" for full repository access
   - Click "Generate token"
   - **IMPORTANT**: Copy the token immediately as you won't be able to see it again

## Domain Setup

1. Configure your domains:
   - Frontend: `management.motto-onprem.auction.innorithm.co`
   - Backend API: `api.motto-onprem.auction.innorithm.co`
2. Point both domains to your server's IP address:
   - Create A records in your domain management panel
   - Set both domains to point to your server IP

## PostgreSQL Database Setup

```bash
# Secure PostgreSQL installation - set superuser password
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'your_secure_password';"

# Create database and user for the auction application
sudo -u postgres createuser motto_auction
sudo -u postgres createdb -O motto_auction motto_auction
sudo -u postgres psql -c "ALTER USER motto_auction WITH PASSWORD 'your_secure_password';"
```

## Database Configuration

Configure your application to use PostgreSQL. Create a db.php file with your database credentials:

```bash
# Create and edit the database configuration
sudo nano /var/www/motto-auction/config/db.php
```

Add the following content to the file:

```php
<?php

$db = [
   'class' => 'yii\db\Connection',
   'dsn' => 'pgsql:host=127.0.0.1;port=5432;dbname=motto_auction',
   'username' => 'motto_auction',
   'password' => 'your_secure_password',
   'charset' => 'utf8',

   // Schema cache options (for production environment)
   'enableSchemaCache' => true,
   'schemaCacheDuration' => 60,
   'schemaCache' => 'cache',
];

return $db;
```

## Backend Deployment (Yii 2)

```bash
# Create backend directory
sudo mkdir -p /var/www/motto-auction

# Set permissions
sudo chown -R www-data:www-data /var/www/motto-auction
sudo chown -R ubuntu:ubuntu /var/www/motto-auction  # Temporary ownership for deployment

# Clone your backend repository using the Personal Access Token directly
cd /var/www
git clone https://YOUR_GITHUB_USERNAME:YOUR_PERSONAL_ACCESS_TOKEN@github.com/innorithm/motto-casting-be.git motto-auction

# For example, with a real token (replace with your actual values):
# git clone https://username:ghp_1a2b3c4d5e6f7g8h9i0j@github.com/innorithm/motto-casting-be.git motto-auction

# Navigate to backend directory
cd /var/www/motto-auction

# Install Composer dependencies
composer install --no-dev --optimize-autoloader

# Copy and configure database connection (adapt file based on the project structure)
cp config/db.php.example config/db.php  # Or similar config file
nano config/db.php  # Edit database connection details with the PostgreSQL config

# Run Yii migrations
./yii migrate --interactive=0

# Initialize RBAC if needed
./yii rbac/init

# Set proper file permissions
sudo mkdir -p runtime web/assets
sudo chown -R www-data:www-data /var/www/motto-auction/runtime
sudo chown -R www-data:www-data /var/www/motto-auction/web/assets
sudo chmod -R 775 /var/www/motto-auction/runtime
sudo chmod -R 775 /var/www/motto-auction/web/assets

# Create tmp directory if needed (similar to existing structure)
sudo mkdir -p /var/www/motto-auction/tmp
sudo chown www-data:www-data /var/www/motto-auction/tmp
```

## Frontend Deployment (Vue)

```bash
# On your local machine, build the Vue project
npm run build

# Create frontend directory on server
sudo mkdir -p /var/www/html/frontend
sudo chown -R ubuntu:ubuntu /var/www/html/frontend

# Upload dist folder to server using SCP
scp -i /path/to/your/key -r dist/* ubuntu@your-server-ip:/var/www/html/frontend/
```

## Apache Configuration

Based on your existing structure, create configuration files for the auction system:

```bash
# Create Apache configuration for frontend
sudo nano /etc/apache2/sites-available/motto-auction-frontend.conf

# Add this configuration:
<VirtualHost *:80>
    ServerAdmin webmaster@innorithm.co
    ServerName management.motto-onprem.auction.innorithm.co
    Protocols h2 http/1.1
    DocumentRoot /var/www/html/frontend
    
    <Directory /var/www/html/frontend>
        Options -Indexes
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/motto-auction-frontend-error.log
    CustomLog ${APACHE_LOG_DIR}/motto-auction-frontend-access.log combined
    
    RewriteEngine on
    RewriteCond %{HTTPS} off
    RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>

# Create Apache configuration for backend API
sudo nano /etc/apache2/sites-available/motto-auction-backend.conf

# Add this configuration:
<VirtualHost *:80>
    ServerAdmin webmaster@innorithm.co
    ServerName api.motto-onprem.auction.innorithm.co
    Protocols h2 http/1.1
    DocumentRoot /var/www/motto-auction/web
    
    <Directory /var/www/motto-auction/web>
        Options -Indexes
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/motto-auction-backend-error.log
    CustomLog ${APACHE_LOG_DIR}/motto-auction-backend-access.log combined
    
    RewriteEngine on
    RewriteCond %{HTTPS} off
    RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>

# Enable the sites
sudo a2ensite motto-auction-frontend.conf
sudo a2ensite motto-auction-backend.conf
sudo systemctl reload apache2
```

## SSL Configuration with Certbot

```bash
# Obtain SSL certificates for both domains
sudo certbot --apache -d management.motto-onprem.auction.innorithm.co
sudo certbot --apache -d api.motto-onprem.auction.innorithm.co

# The SSL configuration files will be created automatically by certbot
# They will follow the naming pattern like motto-auction-frontend-le-ssl.conf
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

## Yii 2 Backend .htaccess

```bash
# Create .htaccess file for Yii 2 backend
sudo nano /var/www/motto-auction/web/.htaccess

# Add this configuration:
RewriteEngine on

# If a directory or a file exists, use it directly
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d

# Otherwise forward it to index.php
RewriteRule . index.php
```

## Schedule Cron Jobs (if needed)

```bash
# Create cron script similar to existing motto-ins structure
sudo nano /var/www/motto-auction/cron.sh

# Add your cron commands

# Make it executable
sudo chmod +x /var/www/motto-auction/cron.sh

# Open crontab for editing
crontab -e

# Add entry to run the cron script
0 * * * * /var/www/motto-auction/cron.sh >> /var/www/motto-auction/runtime/logs/cron.log 2>&1
```

## Manual SSL Certificate Export (If Needed for Domain Registrar)

If your domain registrar requires SSL certificates:

```bash
# Certificate locations after Certbot
sudo ls -la /etc/letsencrypt/live/management.motto-onprem.auction.innorithm.co/

# Export certificate files
sudo cp /etc/letsencrypt/live/management.motto-onprem.auction.innorithm.co/fullchain.pem ~/fullchain.pem
sudo cp /etc/letsencrypt/live/management.motto-onprem.auction.innorithm.co/privkey.pem ~/privkey.pem
sudo chown ubuntu:ubuntu ~/fullchain.pem ~/privkey.pem

# Download to your local machine
scp -i /path/to/your/key ubuntu@your-server-ip:~/fullchain.pem ./
scp -i /path/to/your/key ubuntu@your-server-ip:~/privkey.pem ./
```

## Enabling Apache Modules and Protocols

Make sure all required Apache modules are enabled:

```bash
# Enable required Apache modules
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod rewrite
sudo a2enmod ssl
sudo a2enmod headers
sudo a2enmod http2

# Restart Apache to apply all changes
sudo systemctl restart apache2
```

## Deployment Verification

1. Test frontend access: https://management.motto-onprem.auction.innorithm.co
2. Test backend access: https://api.motto-onprem.auction.innorithm.co
3. Check logs if issues occur:
   ```bash
   sudo tail -f /var/log/apache2/motto-auction-frontend-error.log
   sudo tail -f /var/log/apache2/motto-auction-backend-error.log
   sudo tail -f /var/www/motto-auction/runtime/logs/app.log
   ```

## Quick Redeploy Commands

### Backend Update (Yii 2)

```bash
cd /var/www/motto-auction
git pull
composer install --no-dev --optimize-autoloader
./yii migrate --interactive=0
./yii cache/flush-all
sudo chown -R www-data:www-data runtime web/assets
```

### Frontend Update (Vue)

```bash
# On local machine
npm run build

# Upload to server
scp -i /path/to/your/key -r dist/* ubuntu@your-server-ip:/var/www/html/frontend/
```

## Troubleshooting Common Issues

### PHP Memory Limit

If you encounter memory limit issues, increase PHP memory limit:

```bash
sudo nano /etc/php/8.1/apache2/php.ini
# Find memory_limit and set to
memory_limit = 256M
# Save and restart Apache
sudo systemctl restart apache2
```

### Database Connection Issues

Verify PostgreSQL is running:

```bash
sudo systemctl status postgresql
# If not running
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

Verify database connection settings in your config file:

```bash
nano /var/www/motto-auction/config/db.php

// Ensure these settings match your PostgreSQL configuration
$db = [
   'class' => 'yii\db\Connection',
   'dsn' => 'pgsql:host=127.0.0.1;port=5432;dbname=motto_auction',
   'username' => 'motto_auction',
   'password' => 'your_secure_password',
   'charset' => 'utf8',
   // Schema cache options (for production environment)
   'enableSchemaCache' => true,
   'schemaCacheDuration' => 60,
   'schemaCache' => 'cache',
];
```

### File Permissions

If you encounter permission issues:

```bash
sudo find /var/www/motto-auction/runtime -type d -exec chmod 775 {} \;
sudo find /var/www/motto-auction/runtime -type f -exec chmod 664 {} \;
sudo find /var/www/motto-auction/web/assets -type d -exec chmod 775 {} \;
sudo find /var/www/motto-auction/web/assets -type f -exec chmod 664 {} \;
sudo chown -R www-data:www-data /var/www/motto-auction/runtime
sudo chown -R www-data:www-data /var/www/motto-auction/web/assets
```

### Yii Debug Mode

Make sure to disable debug mode in production:

```bash
nano /var/www/motto-auction/web/index.php

// Ensure YII_DEBUG is set to false
defined('YII_DEBUG') or define('YII_DEBUG', false);
```
