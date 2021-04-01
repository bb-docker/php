#!/bin/sh

# Start services
/etc/init.d/nginx start
/etc/init.d/php8.0-fpm start

# Keep running
/bin/bash