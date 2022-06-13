#!/bin/bash
DEF_NAME="example"
DEF_PORT="80"

CYAN="\e[36m"
GREY="\e[37m"
RESET="\e[0m"

_hint() { echo -e "${GREY}($1)${RESET}"; }
_quest() { echo -e "${CYAN}?${RESET}"; }

cd /var/www/html
read -r -p "$(_quest) Project Name $(_hint $DEF_NAME) " _NAME
read -r -p "$(_quest) Export port $(_hint $DEF_PORT) " _PORT

[ -z "$_NAME" ] && _NAME=$DEF_NAME
[ -z "$_PORT" ] && _PORT=$DEF_PORT

## Use Composer build the project
composer create-project --prefer-dist laravel/laravel $_NAME
cd $_NAME
composer install

## Setup the Nginx
echo "server {
    listen $_PORT;
    root /var/www/html/$_NAME/public;
    index index.html index.htm index.nginx-debian.html index.php;
    server_name _;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
    }
}" > /etc/nginx/sites-available/$_NAME
ln -s /etc/nginx/sites-available/$_NAME /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

## Restart Nginx
/etc/init.d/nginx reload