FROM phpdockerio/php7-fpm:latest

MAINTAINER Jeroen Ketelaar version: 0.1

WORKDIR "/application"

ARG DEBIAN_FRONTEND=noninteractive

ENV LOCALE en_US.UTF-8

ENV TZ=Europe/Amsterdam

RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8

RUN \
    sed -i -e "s/# $LOCALE/$LOCALE/" /etc/locale.gen \
    && echo "LANG=$LOCALE">/etc/default/locale \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=$LOCALE

RUN \
    apt-get -yqq install \
    apt-utils \
    build-essential \
    debconf-utils \
    debconf \
    mysql-client \
    curl \
    software-properties-common \
    python-software-properties

RUN \
    apt-get update

RUN \
    apt-get -yqq install \
    php7.0 \
    php7.0-curl \
    php7.0-bcmath \
    php7.0-bz2 \
    php7.0-dev \
    php7.0-gd \
    php7.0-dom \
    php7.0-imap \
    php7.0-imagick \
    php7.0-intl \
    php7.0-json \
    php7.0-ldap \
    php7.0-mbstring	\
    php7.0-mcrypt \
    php7.0-mysql \
    php7.0-odbc \
    php7.0-ssh2 \
    php7.0-xml \
    php7.0-zip \
    php7.0-apcu \
    php7.0-opcache \
    php7.0-memcache \
    php7.0-memcached \
    php7.0-redis \
    php7.0-xdebug

RUN \
    echo $TZ | tee /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    echo "date.timezone = \"$TZ\";" > /etc/php/7.0/fpm/conf.d/timezone.ini && \
    echo "date.timezone = \"$TZ\";" > /etc/php/7.0/cli/conf.d/timezone.ini

RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN \
    curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -

ENV PATH /usr/local/go/bin:$PATH

RUN \
    go get github.com/mailhog/mhsendmail

RUN \
    cp /root/go/bin/mhsendmail /usr/bin/mhsendmail
