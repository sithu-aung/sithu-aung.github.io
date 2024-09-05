# Vue Project Server Setup

 - sudo apt update
 - sudo apt install -y nodejs nom
 - sudo apt install nginx
 - sudo chown -R ubuntu:ubuntu /var/www/html/

 // Run in Client Side
 - scp -i /Users/dev/Downloads/social_test.pem -r dist/* ubuntu@13.211.121.212:/var/www/html/

### Server Config for both Frontend and Backend
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod rewrite
sudo systemctl restart apache2

# Vite Getting Started
 - npm create vite@latest my-vue-app -- --template vue
