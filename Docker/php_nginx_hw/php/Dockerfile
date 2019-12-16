FROM alpine:3.7

RUN apk add --no-cache php7 php7-fpm php7-mcrypt php7-soap php7-openssl php7-gmp php7-pdo_odbc \
    php7-json php7-dom php7-pdo php7-zip php7-mysqli php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath \
    php7-gd php7-odbc php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader php7-xmlrpc php7-bz2 \
    php7-iconv php7-pdo_dblib php7-curl php7-ctype
RUN adduser -D -g 'www' www
RUN sed -i "s|user\s*=\s*nobody|user = www|g" /etc/php7/php-fpm.d/www.conf
RUN sed -i "s|group\s*=\s*nobody|group = www|g" /etc/php7/php-fpm.d/www.conf
EXPOSE 9000
CMD ["php-fpm7", "--nodaemonize"]
