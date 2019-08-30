FROM php:7.2-apache

RUN apt-get update && apt-get install -y debconf libpq-dev nano r-base

RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo_pgsql pgsql