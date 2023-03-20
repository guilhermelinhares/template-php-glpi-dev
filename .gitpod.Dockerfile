FROM gitpod/workspace-full:latest

USER gitpod

# Change your version here
RUN sudo update-alternatives --set php $(which php8.0)
#Install Xdebug
RUN sudo install-packages php8.0-xdebug && sudo apt autoremove

# Add repositorie PHP
RUN sudo add-apt-repository -y ppa:ondrej/php 
#Install PHP dependencies
RUN sudo apt install php8.0-{cli,imap,ldap,xmlrpc,soap,curl,snmp,zip,apcu,gd,mbstring,mysql,xml,bz2,intl}

#Custom apache configuration
COPY --chown=gitpod:gitpod webserver/apache2/glpi.conf /etc/apache2/sites-available/glpi.conf

#Custom xdebug configuration
RUN sudo mv /etc/php/8.0/cli/conf.d/20-xdebug.ini /etc/php/8.0/cli/conf.d/20-xdebug.ini.bkp
COPY --chown=gitpod:gitpod webserver/xdebug/xdebug.ini /etc/php/8.0/cli/conf.d/xdebug.ini
COPY --chown=gitpod:gitpod webserver/xdebug/xdebug.ini /etc/php/8.0/mods-available/xdebug.ini

#Simbolic Link
RUN ln -s /etc/apache2/sites-available/glpi.conf /etc/apache2/sites-enabled/glpi.conf

