#!/bin/sh

# Start services
/etc/init.d/nginx start
/etc/init.d/php8.1-fpm start

# Keep running
/bin/bash