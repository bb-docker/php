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
mv * ../
mv .e* ../
mv .g* ../
mv .s* ../
cd ../
rm -rf $_NAME
composer install
if [ -f "index.nginx-debian.html" ]; then
    mv index.nginx-debian.html ./public/index.nginx-debian.html.bak
fi
if [ -f "info.php" ]; then
    mv info.php ./public/info.php.bak
fi
if [ -f "sendEmail.php" ]; then
    mv sendEmail.php ./public/sendEmail.php.bak
fi
php artisan key:generate

## Setup the Nginx
echo "#!/bin/bash
# This script created by bananabb/php:/laravel.sh
# This script ran automate by bananabb/php:/entrypoint.sh 
# This script configure Nginx in a Docker container for an existing Laravel application

echo \"server {
    listen $_PORT;
    root /var/www/html/public;
    index index.html index.htm index.nginx-debian.html index.php;
    server_name _;

    location / {
        try_files \$uri \$uri/ /index.php\$is_args\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    }

    error_page 404 /index.php;

    # deny access to hidden files such as .htaccess
    location ~ /\. {
        deny all;
    }
}\" > /etc/nginx/sites-available/$_NAME
ln -s /etc/nginx/sites-available/$_NAME /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
/etc/init.d/nginx reload" > /var/www/html/laravel-site-setup.sh
### Run script to set Nginx
chmod +x /var/www/html/laravel-site-setup.sh
source /var/www/html/laravel-site-setup.sh

## Restart Nginx
/etc/init.d/nginx reload