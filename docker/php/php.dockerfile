FROM php:7.4-fpm

ENV ORACLE_HOME=/usr/lib/oracle/12.2/client64 \
    PATH=$PATH:/usr/lib/oracle/12.2/client64/bin \
    LD_LIBRARY_PATH=/usr/lib/oracle/12.2/client64/lib

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get install -y \
        libpq-dev \
        wget \
		git \
		iputils-ping \
        unzip \
        alien \
        libaio1 \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libxml2-dev \
        libldap2-dev

## REDIS
ENV PHPREDIS_VERSION 3.0.0

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis
		
## get client  Oracle
COPY oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm /tmp/oracle-oci12.rpm
COPY oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm /tmp/oracle-oci12-devel.rpm

## Convert package and config extension
RUN cd /tmp  \
    && alien -i oracle-oci12.rpm oracle-oci12-devel.rpm \
    && docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/lib/oracle/12.2/client64/lib \
    && docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/usr/lib/oracle/12.2/client64/lib

## install xdebug
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

## move php-ini-developemnt to php.ini
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

## Finaly enable and install all in PHP
RUN docker-php-ext-install -j$(nproc) mysqli pgsql oci8 pdo pdo_mysql pdo_pgsql pdo_oci soap ldap  \
    && docker-php-ext-enable xdebug \
    && rm -R /tmp/* \ 
    && apt clean 
