# Use an official PHP runtime as a parent image
FROM php:8.1-apache


# Set the working directory
WORKDIR /var/www/html/


# Install dependencies
RUN apt-get update && apt-get install -y \
   nano \
   git \
   curl \
   libpng-dev \
   libonig-dev \
   libxml2-dev \
   libzip-dev \
   zip \
   unzip \
   gnupg
RUN apt-get install -y libpq-dev

# Install any necessary dependencies
RUN docker-php-ext-install mysqli pdo_mysql mbstring exif pcntl bcmath gd sockets
# Install PGSQL drivers

RUN docker-php-ext-install pdo pdo_pgsql




# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


#Install node js
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN npm install pm2 -g


# Add user for laravel application
# RUN groupadd -g 1000 www
# RUN useradd -u 1000 -ms /bin/bash -g www www


# Set up Apache configuration
COPY apache-config.conf /etc/apache2/sites-enabled/000-default.conf
RUN a2enmod rewrite


# Copy existing application directory contents
COPY . /var/www/html


# RUN cd /var/www/html/
# RUN composer install 


RUN chmod -R 777 /var/www/html/bootstrap
RUN chmod -R 777 /var/www/html/storage


# Expose port 80 for HTTP traffic
EXPOSE 80


# Start Apache in the foreground
CMD ["apache2-foreground"]