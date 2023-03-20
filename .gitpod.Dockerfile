FROM gitpod/workspace-full:latest

USER gitpod

# Add repositorie PHP
RUN sudo add-apt-repository -y ppa:ondrej/php 
#Install PHP dependencies
RUN sudo apt-get install -y php8.0 php8.0-cli php8.0-imap php8.0-ldap php8.0-xmlrpc php8.0-soap php8.0-curl \ 
&& php8.0-snmp php8.0-zip php8.0-apcu php8.0-gd php8.0-mbstring php8.0-mysql php8.0-xml \
&& php8.0-bz2 php8.0-intl && php8.0-cgi \
&& sudo apt-get -y autoremove

# Change your version here
RUN sudo update-alternatives --set php $(which php8.0)
#Install Xdebug
RUN sudo apt install php-xdebug -y && sudo install-packages php8.0-xdebug -y && sudo apt autoremove -y

#Custom apache configuration
COPY --chown=gitpod:gitpod webserver/apache2/glpi.conf /etc/apache2/sites-available/glpi.conf

#Custom xdebug configuration
RUN sudo mv /etc/php/8.0/cli/conf.d/20-xdebug.ini /etc/php/8.0/cli/conf.d/20-xdebug.ini.bkp
COPY --chown=gitpod:gitpod webserver/xdebug/xdebug.ini /etc/php/8.0/cli/conf.d/xdebug.ini
COPY --chown=gitpod:gitpod webserver/xdebug/xdebug.ini /etc/php/8.0/mods-available/xdebug.ini

#Simbolic Link
RUN ln -s /etc/apache2/sites-available/glpi.conf /etc/apache2/sites-enabled/glpi.conf

