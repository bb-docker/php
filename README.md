# php
This repository contains Dockerfile of nginx and php in ubuntu.

## Getting Started
These instructions will get you to build php service with nginx in your docker. See Installation for notes on how to build your ubuntu on a live system.

### Installation
1. Install [Docker](https://www.docker.com/).
2. Download [automated build](https://hub.docker.com/r/bananabb/php/) from public [Docker Hub](https://hub.docker.com/) or run Usage tag provided.
3. Default working directory located in /var/www/html, you can setup specifically
4. Finally, to verify the php and nginx is ready as expected, open `http://your_server_ip/info.php` or `http://your_server_ip` in your browser of choice, after running up the Usage.

### Usage
```
docker pull bananabb/php:latest
docker run -itd --name php -p 8080:80 bananabb/php
docker exec -it php /bin/bash
nginx -t
php -v
composer -V
```

Open `http://localhost:8080/info.php` in your browser of choice, Or use volumes (e.g: `docker run -itd --name php -v {your directory}:/var/www/html -p 8080:80 bananabb/php`) to bind mount your working directory.

## License
MIT © [BananaBb](https://github.com/BananaBb)