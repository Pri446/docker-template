FROM php:8.4-fpm-alpine

ARG UID=1000
ARG GID=1000

ENV UID=${UID}
ENV GID=${GID}

COPY ./php/php.ini /usr/local/etc/php/php.ini

RUN mkdir -p /var/www/html/project_name

WORKDIR /var/www/html/project_name

RUN set -ex \
    && apk update \
    && apk upgrade --no-cache \
    && apk add --no-cache \
        curl \
        postgresql-dev \
        oniguruma-dev \
        libxml2-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        libwebp-dev \
        zlib-dev \
        libxpm-dev \
        libxrender \
        libxext \
        fontconfig \
    && docker-php-ext-configure gd --with-jpeg --with-webp \
    && docker-php-ext-install \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        gd \
        opcache \
    && rm -rf /var/cache/apk/*

RUN delgroup dialout || true

RUN addgroup -g ${GID} --system laravel \
    && adduser -G laravel --system -D -s /bin/sh -u ${UID} laravel

COPY ./php/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p \
        /var/www/html/project_name/storage \
        /var/www/html/project_name/bootstrap/cache \
        /var/log/php \
        /run \
    && chown -R laravel:laravel \
        /var/www/html/project_name/storage \
        /var/www/html/project_name/bootstrap/cache \
        /var/log/php \
        /run

USER laravel

EXPOSE 9000

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD php-fpm -t || exit 1

CMD ["php-fpm"]