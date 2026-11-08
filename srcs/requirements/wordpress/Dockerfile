FROM debian:12

RUN apt-get update && apt-get install -y \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    curl \
    mariadb-client

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN wp --info

COPY ./tools/script.sh /script.sh
RUN chmod 777 /script.sh

ENTRYPOINT [ "/script.sh" ]