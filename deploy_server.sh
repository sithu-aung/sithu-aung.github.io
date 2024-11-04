#!/bin/bash

# Read user input for username, project path, database name, server name, and repository URL
read -p "Enter the username: " USER
read -p "Enter the project path: " PROJECT_PATH
read -p "Enter the database name: " DB_NAME
read -p "Enter the server name (e.g., example.com): " SERVER_NAME
read -p "Enter the Git repository URL: " REPO_URL

# Update and install necessary packages
echo "Updating and installing necessary packages..."
sudo apt update
sudo apt install -y apache2 git php php-cli php-fpm php-json php-mysql php-pgsql php-mbstring php-xml php-curl php-zip libapache2-mod-php postgresql postgresql-contrib composer

# Start and enable PostgreSQL
echo "Starting and enabling PostgreSQL..."
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Check if the PostgreSQL user 'postgres' exists
echo "Checking if the PostgreSQL user 'postgres' exists..."
USER_EXISTS=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='postgres'")

if [ "$USER_EXISTS" == "1" ]; then
  echo "Changing password for existing user 'postgres'..."
  sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"
else
  echo "Creating user 'postgres' with password 'postgres'..."
  sudo -u postgres psql -c "CREATE USER postgres WITH PASSWORD 'postgres';"
fi

# Create a PostgreSQL database
echo "Creating a PostgreSQL database..."
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME;"

# Clone the project repository
echo "Cloning the project repository..."
sudo git clone $REPO_URL $PROJECT_PATH

# Set proper ownership and permissions
echo "Setting proper ownership and permissions..."
sudo chown -R $USER:$USER $PROJECT_PATH
sudo chmod -R 755 $PROJECT_PATH
sudo chown -R www-data:www-data $PROJECT_PATH
sudo chmod -R 755 $PROJECT_PATH
sudo chmod 777 $PROJECT_PATH/runtime/ $PROJECT_PATH/web/assets/

# Create vendor directory
echo "Creating vendor directory..."
mkdir -p $PROJECT_PATH/vendor

# Run Composer install
echo "Running Composer install..."
cd $PROJECT_PATH && composer install

# Configure Apache
echo "Configuring Apache..."
sudo bash -c "cat > /etc/apache2/sites-available/000-default.conf <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName $SERVER_NAME
    DocumentRoot $PROJECT_PATH/web
    <Directory $PROJECT_PATH/web>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF"

# Enable Apache rewrite module
echo "Enabling Apache rewrite module..."
sudo a2enmod rewrite
sudo systemctl restart apache2

# Enable remote access for PostgreSQL
echo "Enabling remote access for PostgreSQL..."
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/16/main/postgresql.conf
sudo bash -c 'echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/16/main/pg_hba.conf'
sudo systemctl restart postgresql

# Open PostgreSQL port in firewall
echo "Opening PostgreSQL port in firewall..."
sudo ufw allow 5432/tcp

# Install and configure Certbot for SSL
echo "Installing and configuring Certbot for SSL..."
sudo apt install -y certbot python3-certbot-apache
sudo certbot --apache

# Set up cron job for SSL certificate renewal
echo "Setting up cron job for SSL certificate renewal..."
(crontab -l ; echo "0 */12 * * * certbot renew --quiet") | crontab -

# Grant permissions for image uploads
echo "Granting permissions for image uploads..."
sudo chmod -R 775 $PROJECT_PATH/uploads/post/
sudo chown -R www-data:www-data $PROJECT_PATH/uploads/post/

echo "Deployment script completed successfully."
