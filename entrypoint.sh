#!/bin/sh

# Start services
/etc/init.d/nginx start
/etc/init.d/php8.2-fpm start

# Keep running
/bin/bash