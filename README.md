# php
This repository contains Dockerfile of nginx, php, nodejs and npm in ubuntu.

## Getting Started
These instructions will get you to build php service with nginx in your docker. See Installation for notes on how to build your ubuntu on a live system.

### Installation
1. Install [Docker](https://www.docker.com/).
2. Download [automated build](https://hub.docker.com/r/bananabb/php/) from public [Docker Hub](https://hub.docker.com/) or run Usage tag provided.
3. Default working directory located in /var/www/html, you can setup specifically
4. Finally, to verify the php and nginx is ready as expected, open `http://your_server_ip:8080/info.php` or `http://your_server_ip:8080` in your browser of choice, after running up the Usage.
5. The verify will be depended on your work. If you use volumes (e.g: `docker run -itd --name php -v {your directory}:/var/www/html -p 8080:80 bananabb/php`) to bind mount your working directory.

### Usage
```
docker pull bananabb/php:latest
docker run -itd --name php -p 8080:80 bananabb/php
docker exec -it php /bin/bash
nginx -t
php -v
composer -V
node -v
npm -v
```

### Restart Services (If you need)
```
/etc/init.d/nginx reload
/etc/init.d/php8.2-fpm restart
```

### Create Laravel project
1. Run command as `/laravel.sh` in docker container
2. Enter your project name 
3. Enter your export port (Please sync with docker export port)
4. The project is located on /var/www/html

### Use [mailhog](https://github.com/mailhog/MailHog) for email testing
1. Create mailhog docker container. (Sample of `docker-compose.yml` attached, please change your content)
2. Change the config as below `Config Setting`
3. Change the your content in sendEmail.php
4. Run `php sendEmail.php`
5. You can check the result on [localhost:8025](http://localhost:8025)

### Config Setting
```
# Enter to php Container
# Find `sendmail_path` and change as below in file `/etc/php/8.2/cli/php.ini`
sendmail_path="/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025"
```

## License
MIT © [BananaBb](https://github.com/BananaBb)