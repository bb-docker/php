FROM bananabb/nginx:1.18.0
MAINTAINER BananaBb

# Install php:8.2 + packages + set HK timezone
ENV TZ=Asia/Hong_Kong
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
 && apt update && apt -y upgrade \
 && add-apt-repository ppa:ondrej/php -y \
 && apt install php8.2 -y \
 && apt install -y \
    php8.2-fpm \
    php8.2-common \
    php8.2-mysql \
    php8.2-sqlite3 \
    php8.2-xml \
    php8.2-xmlrpc \
    php8.2-curl \
    php8.2-gd \
    php8.2-imagick \
    php8.2-cli \
    php8.2-dev \
    php8.2-imap \
    php8.2-mbstring \
    php8.2-opcache \
    php8.2-soap \
    php8.2-cgi \
    php8.2-zip \
    php8.2-redis \
    php8.2-intl \
    php8.2-bcmath

# Setup Server Routing
RUN rm /etc/nginx/sites-available/default
COPY default /etc/nginx/sites-available/default

# File setting
COPY ./info.php /var/www/html/info.php
COPY ./sendEmail.php /var/www/html/sendEmail.php
COPY ./mhsendmail /usr/local/bin/mhsendmail
COPY ./installer /composer-setup.php
COPY ./nodesource_setup.sh /nodesource_setup.sh
COPY ./entrypoint.sh /entrypoint.sh
COPY ./laravel.sh /laravel.sh

# Start the Services
RUN /etc/init.d/nginx reload \
 && /etc/init.d/php8.2-fpm start \
 && chmod +x /nodesource_setup.sh \
 && chmod +x /entrypoint.sh \
 && chmod +x /laravel.sh

# Setup Composer
RUN php /composer-setup.php \
 && mv /composer.phar /usr/local/bin/composer \
 && rm /composer-setup.php

# Setup NodeSource
RUN /nodesource_setup.sh

# Install NPM & Node.js
RUN apt-get update -y \
 && apt-get install -y \
    nodejs \
    build-essential

# Install library for Node.js
RUN npm install -g \
    npm \
    sass

# Remove Node Source Script
RUN rm /nodesource_setup.sh

WORKDIR /var/www/html
EXPOSE 80 443
CMD ["/entrypoint.sh"]