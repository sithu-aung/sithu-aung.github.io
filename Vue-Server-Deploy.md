# Vue Project Server Setup

 - sudo apt update
 - sudo apt install -y nodejs nom
 - sudo apt install nginx
 - sudo chown -R ubuntu:ubuntu /var/www/html/

 - scp -i /Users/dev/Downloads/social_test.pem -r dist/* ubuntu@13.211.121.212:/var/www/html/

# Vite Getting Started
 - npm create vite@latest my-vue-app -- --template vue
