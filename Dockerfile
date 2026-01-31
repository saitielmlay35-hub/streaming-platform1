FROM php:8.2-apache

# Install required PHP extensions and libraries
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libsqlite3-dev libonig-dev \
    && docker-php-ext-install pdo pdo_sqlite zip mbstring

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . /var/www/html

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# Ensure SQLite database file exists
RUN touch database/database.sqlite \
    && chown -R www-data:www-data database

# Set permissions for Laravel
RUN chown -R www-data:www-data storage bootstrap/cache

# Change Apache DocumentRoot to Laravel's public folder
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf \
    && sed -i 's|<Directory /var/www/html>|<Directory /var/www/html/public>|' /etc/apache2/apache2.conf

EXPOSE 80

CMD ["apache2-foreground"]


