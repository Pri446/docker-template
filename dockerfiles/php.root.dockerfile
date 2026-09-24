FROM php:8.4-fpm-alpine

RUN mkdir -p /var/www/html/imis

WORKDIR /var/www/html/imis

RUN sed -i "s/user = www-data/user = root/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = root/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

RUN apk add --no-cache libpq libzip postgresql-dev libzip-dev \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql pgsql zip \
    && apk del postgresql-dev libzip-dev

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
