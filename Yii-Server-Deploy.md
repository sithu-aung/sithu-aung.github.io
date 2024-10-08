
# Server Setup Guide

### Yii Project Server Setup

 - ssh -i your_key.pem ubuntu@public_ip
 - sudo apt update
 - sudo apt install apache2 || ngnix
 - sudo apt install git
 - sudo apt install php php-cli php-fpm php-json php-mysql php-pgsql php-mbstring php-xml php-curl php-zip
 - sudo apt install libapache2-mod-php

 - sudo apt install postgresql postgresql-contrib
 - sudo systemctl start postgresql
 - sudo systemctl enable postgresql

### create database
 - sudo -u postgres psql
 - CREATE DATABASE social;

### clone project
 - sudo git clone https://secret_key@github.com/sithu-aung/social-test.git

### install composer
 - sudo apt install composer 
or
 - curl -sS https://getcomposer.org/installer | php
 - sudo mv composer.phar /usr/local/bin/composer

### Ensure you have proper ownership and permissions
 - sudo chown -R $USER:$USER /var/www/social-test
 - sudo chmod -R 755 /var/www/social-test

 - sudo chown -R www-data:www-data /var/www/social-test
 - sudo chmod -R 755 /var/www/social-test


### Manually create the vendor directory
 - mkdir -p /var/www/social-test/vendor

### Run Composer install
 - composer install

### Check disk space if needed
 - df -h

 - sudo apt-get install php-pgsql

 - sudo chmod 777 runtime/ web/assets/

### change Postgres user name/password(if Required)

 - sudo -u postgres psql
 - ALTER USER your_username WITH PASSWORD 'new_password';

### Rename Username

 - psql -U postgres
 - ALTER ROLE old_username RENAME TO new_username;
 - sudo systemctl restart postgresql

 - sudo a2enmod rewrite

### Default Server Configs
   - For Apache2 ( /etc/apache2/sites-available/000-default.conf)

         VirtualHost *:80>
         # The ServerName directive sets the request scheme, hostname and port that
         # the server uses to identify itself. This is used when creating
         # redirection URLs. In the context of virtual hosts, the ServerName
         # specifies what hostname must appear in the request's Host: header to
         # match this virtual host. For the default virtual host (this file) this
         # value is not decisive as it is used as a last resort host regardless.
         # However, you must set it for any further virtual host explicitly.
         #ServerName www.example.com

         ServerAdmin webmaster@localhost
         ServerName 13.55.159.250
         DocumentRoot /var/www/learnwithus_backend/web

         # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
         # error, crit, alert, emerg.
         # It is also possible to configure the loglevel for particular
         # modules, e.g.
         #LogLevel info ssl:warn

         <Directory /var/www/learnwithus_backend/web>
            Options Indexes FollowSymLinks
            AllowOverride All
            Require all granted
         </Directory>


          ErrorLog ${APACHE_LOG_DIR}/error.log
          CustomLog ${APACHE_LOG_DIR}/access.log combined

          # For most configuration files from conf-available/, which are
          # enabled or disabled at a global level, it is possible to
          # include a line for only one particular virtual host. For example the
          # following line enables the CGI configuration for this host only
          # after it has been globally disabled with "a2disconf".
          #Include conf-available/serve-cgi-bin.conf
    </VirtualHost>
   

   - For Nginx ( ect/nginx/sites-available/000-defaul.conf )

    server {
    charset utf-8;
    client_max_body_size 128M;

    listen 80; ## listen for ipv4
    #listen [::]:80 default_server ipv6only=on; ## listen for ipv6

    server_name 13.55.159.250;
    root        /var/www/learnwithus_backend/web;
    index       index.php;

    access_log  /path/to/basic/log/access.log;
    error_log   /path/to/basic/log/error.log;

    location / {
        # Redirect everything that isn't a real file to index.php
        try_files $uri $uri/ /index.php$is_args$args;
    }

    # uncomment to avoid processing of calls to non-existing static files by Yii
    #location ~ \.(js|css|png|jpg|gif|swf|ico|pdf|mov|fla|zip|rar)$ {
    #    try_files $uri =404;
    #}
    #error_page 404 /404.html;

    # deny accessing php files for the /assets directory
    location ~ ^/assets/.*\.php$ {
        deny all;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass 127.0.0.1:9000;
        #fastcgi_pass unix:/var/run/php5-fpm.sock;
        try_files $uri =404;
    }

    location ~* /\. {
        deny all;
    }
    }

### Enable Remote Access to connect from Navicat

 - sudo nano /etc/postgresql/16/main/postgresql.conf
 - delete comment on #listen_address = 'localhost' -> listen_address = '*'
 - sudo nano /etc/postgresql/16/main/pg_hba.conf

 From 
       
       # IPv4 local connections: 
       host    all             all             127.0.0.1/32            md5

To

       # IPv4 local connections: 
       host    all             all             127.0.0.1/32            md5 
       
  - sudo ufw allow 5432/tcp
  - sudo service postgresql restart

  - Add Inbound Rule for ( 5432 port in EC2 Dashboard-> Security Tab-> Actions-> Edit Inbound Rules

### Copy Config from installation
 - https://www.yiiframework.com/doc/guide/2.0/en/start-installation

 - https://www.digitalocean.com/community/tutorials/how-to-install-lamp-stack-on-ubuntu

————————————————————
### Certbot 

 - sudo apt update
 - sudo apt install certbot python3-certbot-apache
 - sudo certbot —apache

### Manual SSL Config
 - sudo nano /etc/apache2/sites-available/000-default.conf

       <VirtualHost *:443>
       ServerName your-domain.com
       DocumentRoot /var/www/html
       SSLEngine on
       SSLCertificateFile /etc/letsencrypt/live/your-domain.com/fullchain.pem
       SSLCertificateKeyFile /etc/letsencrypt/live/your-domain.com/privkey.pem
       <Directory /var/www/html>
          AllowOverride All
       </Directory>
       ErrorLog ${APACHE_LOG_DIR}/error.log
       CustomLog ${APACHE_LOG_DIR}/access.log combined</VirtualHost>
       <VirtualHost *:80>
       ServerName your-domain.com
       Redirect permanent / https://your-domain.com/
       </VirtualHost>


### Enable SSL
 - sudo a2enmod ssl
 - sudo a2ensite 000-default.conf
 - sudo systemctl reload apache2

### Cron for Renewal
 - sudo crontab -e
 - 0 */12 * * * certbot renew --quiet
 - sudo certbot renew --dry-run

——————————————————————

### For Image Uploads

### create and grant permission for image folder
  - chmod -R 775 uploads/post/


### increase image size in php.ini configuration
  - php -i | grep "Loaded Configuration File" ( On Server  - Detecting Path)
  - upload_max_filesize = 10M ( Maximum File Size)
 - post_max_size = 10M ( Maximum Post Request Data Size )


### For Server side ( Prevent From All Access )

1. Store outside of webroot folder
2.  For Apache  - Use .htaccess file 

   -  touch /path/to/uploads/.htaccess
   
  (Add these 2 lines)
   Order Allow,Deny
   Deny from all

  ( For Nginx)
  
  1. Open your Nginx configuration file (e.g., /etc/nginx/sites-available/default
  2. Add these 2 Lines 
  > **_NOTE:_** location /uploads/ {
       deny all;
   }
 
### Grant Access to new folder
 - sudo chown -R www-data:www-data /var/www/social-test/uploads/post/


 - sudo nano /etc/postgresql/16/main/pg_hba.conf
-host    all             all             0.0.0.0/0               md5

 - sudo nano /etc/postgresql/16/main/postgresql.conf
-listen_addresses = '*'                  # what IP address(es) to listen on;.

 - sudo service postgresql restart


 - cd /var/log/apache2/
 - cat error.log


 - chmod 400 /Users/dev/Downloads/social_test.pem
 - ssh -i /Users/dev/Downloads/social_test.pem ec2-user@3.27.48.136

### New Amazon Linux
 - sudo yum install -y nginx
 - sudo service nginx start
 - sudo chkconfig nginx on

### Old Amazon Linux
 - sudo yum install -y nginx
 - sudo service nginx start
 - sudo chkconfig nginx on

### Postgres Config
sudo nano postgresql.conf
