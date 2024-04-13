FROM bananabb/nginx:1.24
MAINTAINER BananaBb

# Install php:8.3 + packages + set HK timezone
ENV TZ=Asia/Hong_Kong
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
 && apt update && apt -y upgrade \
 && apt install -y \
    php \
    php-fpm \
    php-common \
    php-mysql \
    php-sqlite3 \
    php-xml \
    php-xmlrpc \
    php-curl \
    php-gd \
    php-imagick \
    php-cli \
    php-dev \
    php-imap \
    php-mbstring \
    php-opcache \
    php-soap \
    php-cgi \
    php-zip \
    php-redis \
    php-intl \
    php-bcmath

# Setup Server Routing
RUN rm /etc/nginx/sites-available/default
COPY default /etc/nginx/sites-available/default

# File setting
COPY ./info.php /var/www/html/info.php
COPY ./sendEmail.php /var/www/html/sendEmail.php
COPY ./mhsendmail /usr/local/bin/mhsendmail
COPY ./installer /composer-setup.php
COPY ./entrypoint.sh /entrypoint.sh
COPY ./laravel.sh /laravel.sh

# Start the Services
RUN /etc/init.d/nginx reload \
 && /etc/init.d/php8.3-fpm start \
 && chmod +x /entrypoint.sh \
 && chmod +x /laravel.sh

# Setup Composer
RUN php /composer-setup.php \
 && mv /composer.phar /usr/local/bin/composer \
 && rm /composer-setup.php

WORKDIR /var/www/html
EXPOSE 80 443
CMD ["/entrypoint.sh"]