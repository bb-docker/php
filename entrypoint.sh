#!/bin/sh

# Start services
/etc/init.d/nginx start
/etc/init.d/php8.3-fpm start

# Setup Laravel Nginx
if [ -f "/var/www/html/laravel-site-setup.sh" ]; then
    source /var/www/html/laravel-site-setup.sh
fi

# Keep running
/bin/bash