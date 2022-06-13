FROM bananabb/nginx:1.18.0
MAINTAINER BananaBb

# Install php:8.1 + packages + set HK timezone
ENV TZ=Asia/Hong_Kong
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
 && apt-add-repository ppa:ondrej/nginx -y \
 && apt-get update -y \
 && apt-get -qq install -y \
    php8.1-fpm \
    php8.1-common \
    php8.1-mysql \
    php8.1-sqlite3 \
    php8.1-xml \
    php8.1-xmlrpc \
    php8.1-curl \
    php8.1-gd \
    php8.1-imagick \
    php8.1-cli \
    php8.1-dev \
    php8.1-imap \
    php8.1-mbstring \
    php8.1-opcache \
    php8.1-soap \
    php8.1-zip \
    php8.1-redis \
    php8.1-intl \
    php8.1-bcmath

# Setup Server Routing
RUN rm /etc/nginx/sites-available/default
COPY default /etc/nginx/sites-available/default

# File setting
COPY ./info.php /var/www/html/info.php
COPY ./installer /composer-setup.php
COPY ./entrypoint.sh /entrypoint.sh
COPY ./laravel.sh /laravel.sh

# Start the Services
RUN /etc/init.d/nginx reload \
 && /etc/init.d/php8.1-fpm start \
 && chmod +x /entrypoint.sh \
 && chmod +x /laravel.sh

# Setup Composer
RUN php /composer-setup.php \
 && mv /composer.phar /usr/local/bin/composer \
 && rm /composer-setup.php

WORKDIR /var/www/html
EXPOSE 80 443
CMD ["/entrypoint.sh"]