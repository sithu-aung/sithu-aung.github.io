#!/bin/bash

# Read user input for username, project path, database name, server name, and repository URL
read -p "Enter the username: " USER
read -p "Enter the project path: " PROJECT_PATH
read -p "Enter the database name: " DB_NAME
read -p "Enter the server name (e.g., example.com): " SERVER_NAME
read -p "Enter the Git repository URL: " REPO_URL

# Function to echo and execute commands
execute_step() {
  echo "Executing: $1"
  eval $1
}

# Update and install necessary packages
execute_step "sudo apt update"
execute_step "sudo apt install -y apache2 git php php-cli php-fpm php-json php-mysql php-pgsql php-mbstring php-xml php-curl php-zip libapache2-mod-php postgresql postgresql-contrib composer"

# Start and enable PostgreSQL
execute_step "sudo systemctl start postgresql"
execute_step "sudo systemctl enable postgresql"

# Check if the PostgreSQL user 'postgres' exists
USER_EXISTS=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='postgres'")

if [ "$USER_EXISTS" == "1" ]; then
  # Change password for existing user 'postgres'
  execute_step "sudo -u postgres psql -c \"ALTER USER postgres WITH PASSWORD 'postgres';\""
else
  # Create user 'postgres' with password 'postgres'
  execute_step "sudo -u postgres psql -c \"CREATE USER postgres WITH PASSWORD 'postgres';\""
fi

# Create a PostgreSQL database
execute_step "sudo -u postgres psql -c \"CREATE DATABASE $DB_NAME;\""

# Clone the project repository
execute_step "sudo git clone $REPO_URL $PROJECT_PATH"

# Set proper ownership and permissions
execute_step "sudo chown -R $USER:$USER $PROJECT_PATH"
execute_step "sudo chmod -R 755 $PROJECT_PATH"
execute_step "sudo chown -R www-data:www-data $PROJECT_PATH"
execute_step "sudo chmod -R 755 $PROJECT_PATH"

# Create vendor directory
execute_step "mkdir -p $PROJECT_PATH/vendor"

# Run Composer install
execute_step "cd $PROJECT_PATH && composer install"

# Configure Apache
execute_step "sudo bash -c \"cat > /etc/apache2/sites-available/000-default.conf <<EOF
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
EOF\""

# Enable Apache rewrite module
execute_step "sudo a2enmod rewrite"
execute_step "sudo systemctl restart apache2"

# Enable remote access for PostgreSQL
execute_step "sudo sed -i \"s/#listen_addresses = 'localhost'/listen_addresses = '*'/g\" /etc/postgresql/16/main/postgresql.conf"
execute_step "sudo bash -c 'echo \"host all all 0.0.0.0/0 md5\" >> /etc/postgresql/16/main/pg_hba.conf'"
execute_step "sudo systemctl restart postgresql"

# Open PostgreSQL port in firewall
execute_step "sudo ufw allow 5432/tcp"

# Install and configure Certbot for SSL
execute_step "sudo apt install -y certbot python3-certbot-apache"
execute_step "sudo certbot --apache"

# Set up cron job for SSL certificate renewal
execute_step "(crontab -l ; echo \"0 */12 * * * certbot renew --quiet\") | crontab -"

# Grant permissions for image uploads
execute_step "sudo chmod -R 775 $PROJECT_PATH/uploads/post/"
execute_step "sudo chown -R www-data:www-data $PROJECT_PATH/uploads/post/"

echo "Deployment script completed successfully."
