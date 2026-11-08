#!/bin/bash

if [ ! -f /var/www/html/wp-config.php ]; then
    mkdir -p /var/www/html
    curl -O https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r wordpress/* /var/www/html/
    rm -rf wordpress latest.tar.gz
    mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    chmod 777 /var/www/html
fi

db_pwd=$(cat /run/secrets/db_pwd)
wp_admin_pwd=$(cat /run/secrets/admin_pwd)
wp_user_pwd=$(cat /run/secrets/user_pwd)

sed -i "s/database_name_here/$db_name/" /var/www/html/wp-config.php
sed -i "s/username_here/$db_user/" /var/www/html/wp-config.php
sed -i "s/password_here/$db_pwd/" /var/www/html/wp-config.php
sed -i "s/localhost/mariadb:$port/" /var/www/html/wp-config.php

until mariadb -h mariadb -u "$db_user" -P "$port" -p"$db_pwd" "$db_name" -e "SELECT 1" >/dev/null 2>&1
do
    sleep 1
done

wp  --allow-root core install \
    --path=/var/www/html \
    --url="https://$domain" \
    --title="My WordPress" \
    --admin_user="$wp_admin_user" \
    --admin_password="$wp_admin_pwd" \
    --admin_email="$wp_admin_email"

wp  --allow-root user create \
    "$wp_user" \
    "$wp_user_email" \
    --role=subscriber \
    --user_pass="$wp_user_pwd" \
    --path=/var/www/html

sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/g' /etc/php/8.2/fpm/pool.d/www.conf

exec php-fpm8.2 -F