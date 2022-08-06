FROM composer as composer
COPY ./src /app
RUN composer install --ignore-platform-reqs --no-scripts

FROM php:8.0.3-fpm-buster
WORKDIR /var/www
RUN apt-get update && apt-get install -y \
        git \
        zip \
        unzip \
    && docker-php-ext-install bcmath pdo_mysql

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - 
RUN apt-get install -y nodejs
RUN npm install

COPY ./src /var/www
COPY --from=composer /app/vendor /var/www/vendor

EXPOSE 9000