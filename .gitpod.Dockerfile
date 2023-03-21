FROM gitpod/workspace-full

USER gitpod
ENV PHP_VERSION="7.4"

ENV APACHE_DOCROOT_IN_REPO="glpi"
# Change your version here
# RUN sudo update-alternatives --set php $(which php${PHP_VERSION})

# Install PHP Dependencies + Xdebug + Mysql
RUN sudo apt-get update -q  \
&& sudo install-packages -yq \
php-pear \
libapache2-mod-php \
php${PHP_VERSION}-cli \
php${PHP_VERSION}-imap \
php${PHP_VERSION}-xmlrpc \
php${PHP_VERSION}-soap \
php${PHP_VERSION}-cgi \
php${PHP_VERSION}-curl \
php${PHP_VERSION}-snmp \
php${PHP_VERSION}-zip \
php${PHP_VERSION}-apcu \
php${PHP_VERSION}-gd \
php${PHP_VERSION}-mbstring \
php${PHP_VERSION}-mysql \
php${PHP_VERSION}-xml \
php${PHP_VERSION}-bz2 \
php${PHP_VERSION}-intl \
php${PHP_VERSION}-ldap \
php${PHP_VERSION}-dev \
php${PHP_VERSION}-intl \
php${PHP_VERSION}-fpm \
&& sudo apt autoremove -y

#Install Xdebug
RUN sudo touch /var/log/xdebug.log \
    && sudo chmod 666 /var/log/xdebug.log

RUN sudo apt-get update -q \
    && sudo apt-get install -y php-dev php${PHP_VERSION}-xdebug php-xdebug 
#Custom xdebug configuration
# COPY --chown=gitpod:gitpod config/xdebug/20-xdebug.ini /etc/php/${PHP_VERSION}/cli/conf.d/20-xdebug.ini

RUN sudo addgroup gitpod www-data

# Install MySQL
RUN sudo install-packages mysql-server \
 && sudo mkdir -p /var/run/mysqld /var/log/mysql \
 && sudo chown -R gitpod:gitpod /etc/mysql /var/run/mysqld /var/log/mysql /var/lib/mysql /var/lib/mysql-files /var/lib/mysql-keyring /var/lib/mysql-upgrade

# Install our own MySQL config
COPY --chown=gitpod:gitpod config/mysql/mysql.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

# Install default-login for MySQL clients
COPY --chown=gitpod:gitpod config/mysql/client.cnf /etc/mysql/mysql.conf.d/client.cnf

COPY --chown=gitpod:gitpod config/mysql/mysql-bashrc-launch.sh /etc/mysql/mysql-bashrc-launch.sh

RUN sudo chmod 775 /etc/mysql/mysql-bashrc-launch.sh && echo "/etc/mysql/mysql-bashrc-launch.sh" >> /home/gitpod/.bashrc.d/100-mysql-launch