# Vue Project Server Setup

 - sudo apt update
 - sudo apt install -y nodejs nom
 - sudo apt install nginx
 - sudo chown -R ubuntu:ubuntu /var/www/html/

 // Run in Client Side
 - scp -i /Users/dev/Downloads/social_test.pem -r dist/* ubuntu@13.211.121.212:/var/www/html/
 - scp -i /Users/dev/Desktop/Dev/devssh -r dist/* root@170.64.231.139:/var/www/html/

### Server Config for both Frontend and Backend
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod rewrite
sudo systemctl restart apache2

    <VirtualHost *:80>
    ServerAdmin webmaster@yourdomain.com
    ServerName todolist.mooo.com
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/frontend_error.log
    CustomLog ${APACHE_LOG_DIR}/frontend_access.log combined
    RewriteEngine on
    RewriteCond %{SERVER_NAME} =todolist.mooo.com
    RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
    </VirtualHost>

# Vite Getting Started
 - npm create vite@latest my-vue-app -- --template vue
