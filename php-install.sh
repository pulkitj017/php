export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get install -y \
    software-properties-common \
    git \
    curl \
    wget \
    gawk \
    unzip \
    zip \
    jq \
    tzdata \
    libicu70
add-apt-repository ppa:ondrej/php -y
apt-get update && apt-get install -y \
    php8.2 \
    php8.2-dom \
    php8.2-xml \
    php8.2-curl \
    php8.2-zip
php -v
curl -sS https://getcomposer.org/installer -o composer-setup.php
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
composer --version
composer install --no-interaction || echo "Composer install skipped or failed"
