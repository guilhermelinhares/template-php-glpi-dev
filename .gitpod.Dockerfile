FROM gitpod/workspace-full:latest

USER gitpod
ENV PHP_VERSION="8.0"

# Change your version here
RUN sudo update-alternatives --set php $(which php${PHP_VERSION})

# Install PHP Dependencies + Xdebug + Mysql
RUN sudo apt-get update -q  \
&& sudo install-packages -yq \
libapache2-mod-php \
php${PHP_VERSION}-cli \
php${PHP_VERSION}-imap \
php${PHP_VERSION}-xmlrpc \
php${PHP_VERSION}-soap \
php${PHP_VERSION}-xdebug \
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
&& sudo apt autoremove -y

#Custom apache configuration
COPY --chown=gitpod:gitpod config/apache2/apache.conf /etc/apache2/sites-available/apache.conf

#Custom xdebug configuration
RUN sudo mv /etc/php/${PHP_VERSION}/cli/conf.d/20-xdebug.ini /etc/php/${PHP_VERSION}/cli/conf.d/20-xdebug.ini.bkp
COPY --chown=gitpod:gitpod config/xdebug/xdebug.ini /etc/php/${PHP_VERSION}/cli/conf.d/xdebug.ini
COPY --chown=gitpod:gitpod config/xdebug/xdebug.ini /etc/php/${PHP_VERSION}/mods-available/xdebug.ini

#Simbolic Link
RUN ln -s /etc/apache2/sites-available/apache.conf /etc/apache2/sites-enabled/apache.conf

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