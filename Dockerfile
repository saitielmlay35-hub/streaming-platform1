FROM php:8.2-apache

# Install required PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libsqlite3-dev \
    && docker-php-ext-install pdo pdo_sqlite zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy project files
COPY . /var/www/html

WORKDIR /var/www/html

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# Ensure SQLite database file exists
RUN touch database/database.sqlite \
    && chown -R www-data:www-data database

# Set permissions for Laravel
RUN chown -R www-data:www-data storage bootstrap/cache

EXPOSE 80

CMD ["apache2-foreground"]
