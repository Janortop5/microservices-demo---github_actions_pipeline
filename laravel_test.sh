export DEBIAN_FRONTEND=noninteractive

apt update \
    && apt install nginx wget lsb-release software-properties-common -y

cp -r ./laravel-realworld-example-app /var/www/html/laravel-realworld-example-app

cp ./.env.example /var/www/html/laravel-realworld-example-app/.env

apt install apt-transport-https gnupg2 ca-certificates -y

apt install php8.1-fpm libapache2-mod-php php php-common php-xml php-gd php8.1-opcache php-mbstring php-tokenizer \
    php-json php-bcmath php-zip unzip curl php8.1-curl php8.1-mbstring php8.1-xml zip php-mysql php8.1-mysql vim git -y

cp ./php.ini /etc/php/8.1/fpm/php.ini

cp ./laravel /etc/nginx/sites-available/laravel

cp ./web.php /var/www/html/laravel-realworld-example-app/routes/web.php

cd /var/www/html/

chown -R www-data:www-data /var/www/html/laravel-realworld-example-app/ \
    && chmod -R 775 /var/www/html/laravel-realworld-example-app/

curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer

update-alternatives --set php /usr/bin/php8.1

cd /var/www/html/laravel-realworld-example-app/

composer create-project --no-interaction

ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/

rm /etc/nginx/sites-enabled/default

service nginx reload && service php8.1-fpm restart

php artisan migrate --seed

php artisan test
