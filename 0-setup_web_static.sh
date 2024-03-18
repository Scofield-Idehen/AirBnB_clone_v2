#!/usr/bin/env bash
# Set up a web server for deployment of the web_static.

# Update the package list and install Nginx
sudo apt-get update
sudo apt-get install -y nginx

# Create necessary directories
sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/

# Create a simple HTML file for testing
echo "Holberton School" > /data/web_static/releases/test/index.html

# Create a symbolic link to the current release
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Set ownership and group for the /data directory
sudo chown -R ubuntu:ubuntu /data/

# Configure Nginx
sudo printf "%s\n" "server {
    listen 80 default_server;
    listen [::]:80 default_server;
    add_header X-Served-By \$HOSTNAME;
    root /var/www/html;
    index index.html index.htm;

    location /hbnb_static {
        alias /data/web_static/current;
        index index.html index.htm;
    }

    location /redirect_me {
        return 301 http://cuberule.com/;
    }

    error_page 404 /404.html;
    location /404 {
        root /var/www/html;
        internal;
    }
}" > /etc/nginx/sites-available/default

# Restart Nginx to apply changes
sudo service nginx restart

