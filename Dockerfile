FROM bananabb/nginx:1.18.0
MAINTAINER BananaBb

# Install php:8.0.3 + packages + set HK timezone
ENV TZ=Asia/Hong_Kong
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
 && apt-add-repository ppa:ondrej/php -y \
 && apt-get update -y \
 && apt-get -qq install -y \
    php8.0-fpm \
    php8.0-cli \
    php8.0-fpm \
    php8.0-bcmath \
    php8.0-curl \
    php8.0-gd \
    php8.0-intl \
    php8.0-mbstring \
    php8.0-mysql \
    php8.0-opcache \
    php8.0-sqlite3 \
    php8.0-xml \
    php8.0-zip \
    sendmail

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
 && /etc/init.d/php8.0-fpm start \
 && chmod +x /entrypoint.sh \
 && chmod +x /laravel.sh

# Setup Composer
RUN php /composer-setup.php \
 && mv /composer.phar /usr/local/bin/composer \
 && rm /composer-setup.php

WORKDIR /var/www/html
EXPOSE 80 443
CMD ["/entrypoint.sh"]