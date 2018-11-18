#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#


ARG PHP_VERSION=${PHP_VERSION}

FROM php:${PHP_VERSION}-fpm-alpine

LABEL maintainer="Arthur Li <li_ahui@126.com>"

# If you're in China, or you need to change sources, will be set CHANGE_SOURCE to true in .env.

ARG CHANGE_SOURCE=false
RUN if [ ${CHANGE_SOURCE} = true ]; then \
    # Change application source from dl-cdn.alpinelinux.org to aliyun source
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
;fi

# always run apt update when start and after add new source list, then clean up at end.
RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* \
    && apk add --no-cache --update --virtual .build-deps $PHPIZE_DEPS \
    && pecl channel-update pecl.php.net \
    && apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
    docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    docker-php-ext-install -j${NPROC} gd \
    && rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* 

#
#--------------------------------------------------------------------------
# Optional Software's Installation
#--------------------------------------------------------------------------
#
# Optional Software's will only be installed if you set them to `true`
# in the `.env` before the build.
# Example:
#   - INSTALL_ZIP_ARCHIVE=true
#


###########################################################################
# xDebug:
###########################################################################

ARG INSTALL_XDEBUG=false

RUN if [ ${INSTALL_XDEBUG} = true ]; then \
  # Install the xdebug extension
  if [ $(php -r "echo PHP_MAJOR_VERSION;") = "5" ]; then \
    pecl install xdebug-2.5.5; \
  else \
    pecl install xdebug; \
  fi && \
  docker-php-ext-enable xdebug \
;fi

# Copy xdebug configuration for remote debugging
COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

###########################################################################
# Blackfire:
###########################################################################

ARG INSTALL_BLACKFIRE=false

RUN if [ ${INSTALL_XDEBUG} = false -a ${INSTALL_BLACKFIRE} = true ]; then \
    version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
;fi

###########################################################################
# PHP REDIS EXTENSION
###########################################################################

ARG INSTALL_PHPREDIS=false

RUN if [ ${INSTALL_PHPREDIS} = true ]; then \
    # Install Php Redis Extension
    printf "\n" | pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis \
;fi

###########################################################################
# Swoole EXTENSION
###########################################################################

ARG INSTALL_SWOOLE=false

RUN if [ ${INSTALL_SWOOLE} = true ]; then \
    # Install Php Swoole Extension
    if [ $(php -r "echo PHP_MAJOR_VERSION;") = "5" ]; then \
      pecl install swoole-2.0.11; \
    else \
      if [ $(php -r "echo PHP_MINOR_VERSION;") = "0" ]; then \
        pecl install swoole-2.2.0; \
      else \
        pecl install swoole; \
      fi \
    fi && \
    docker-php-ext-enable swoole \
;fi

###########################################################################
# MongoDB:
###########################################################################

ARG INSTALL_MONGO=false

RUN if [ ${INSTALL_MONGO} = true ]; then \
    # Install the mongodb extension
    apk add --no-cache --update libressl-dev && \
    wget https://github.com/mongodb/mongo-php-driver/releases/download/1.5.3/mongodb-1.5.3.tgz -O /tmp/mongodb.tar.tgz \
    && pecl install /tmp/mongodb.tar.tgz \
    && rm -rf /tmp/mongodb.tar.tgz \
    #pecl install mongodb && \
    && docker-php-ext-enable mongodb \
;fi

###########################################################################
# SeasLog:
###########################################################################

ARG INSTALL_SEASLOG=false

RUN if [ ${INSTALL_SEASLOG} = true ]; then \
    # Install the SeasLog extension
    wget https://github.com/SeasX/SeasLog/archive/SeasLog-1.8.6.tar.gz -O /tmp/seaslog.tar.gz \
    && cd /tmp \
    && mkdir -p seaslog \
    && tar -xf seaslog.tar.gz -C seaslog --strip-components=1 \
    && rm seaslog.tar.gz \
    && ( \
        cd seaslog \
        && phpize \
        && ./configure \
        && make -j${NPROC} \
        && make install \
    ) \
    && rm -r seaslog \
    #pecl install seaslog && \
    && docker-php-ext-enable seaslog \
;fi

# Copy seaslog configration
COPY ./seaslog.ini /usr/local/etc/php/conf.d/seaslog.ini

###########################################################################
# ZipArchive:
###########################################################################

ARG INSTALL_ZIP_ARCHIVE=false

RUN if [ ${INSTALL_ZIP_ARCHIVE} = true ]; then \
    # Install the zip extension
    docker-php-ext-install zip \
    #apk add docker-php-ext-configure \
    #--with-zlib-dir=/usr && docker-php-ext-install zip \
;fi


###########################################################################
# PHP Memcached:
###########################################################################

ARG INSTALL_MEMCACHED=false

RUN if [ ${INSTALL_MEMCACHED} = true ]; then \
    # Install the php memcached extension
    if [ $(php -r "echo PHP_MAJOR_VERSION;") = "5" ]; then \
      curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/2.2.0.tar.gz"; \
    else \
      curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz"; \
    fi \
    && mkdir -p memcached \
    && tar -C memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
    && ( \
        cd memcached \
        && phpize \
        && ./configure \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r memcached \
    && rm /tmp/memcached.tar.gz \
    && docker-php-ext-enable memcached \
;fi



###########################################################################
# Opcache:
###########################################################################

ARG INSTALL_OPCACHE=false

RUN if [ ${INSTALL_OPCACHE} = true ]; then \
    docker-php-ext-install opcache \
;fi

# Copy opcache configration
COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini

###########################################################################
# Mysqli Modifications:
###########################################################################

ARG INSTALL_MYSQLI=false

RUN if [ ${INSTALL_MYSQLI} = true ]; then \
    docker-php-ext-install mysqli \
;fi

###########################################################################
# PDO_Mysql Modifications:
###########################################################################

ARG INSTALL_PDO_MYSQL=false

RUN if [ ${INSTALL_PDO_MYSQL} = true ]; then \
    docker-php-ext-install pdo_mysql \
;fi

# Composer

ARG INSTALL_COMPOSER=false

RUN if [ ${INSTALL_COMPOSER} = true ]; then \
    curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer self-update --clean-backups \
;fi

###########################################################################
# Check PHP version:
###########################################################################

ARG PHP_VERSION=${PHP_VERSION}

RUN php -v | head -n 1 | grep -q "PHP ${PHP_VERSION}."

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

#COPY ./xink.ini /usr/local/etc/php/conf.d
COPY ./xlaravel.pool.conf /usr/local/etc/php-fpm.d/

# iconv https://github.com/docker-library/php/issues/240

RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Clean up
RUN apk add --no-cache git \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* /usr/share/man \
    && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

USER root

RUN chown -R www-data /var/log/www/

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
