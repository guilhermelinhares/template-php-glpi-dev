FROM gitpod/workspace-mysql

USER gitpod

#Install PHP-Dependencies
RUN sudo apt-get update
# RUN sudo apt-get update && sudo apt install php8.0-{cli,imap,ldap,xmlrpc,soap,curl,snmp,zip,apcu,gd,mbstring,mysql,xml,bz2,intl}
#Install Xdebug
RUN sudo apt install php-xdebug php8.0-xdebug php8.0 php8.0-cgi

#Custom apache configuration
COPY webserver/apache2/glpi.conf /etc/apache2/sites-available/glpi.conf

#Simbolic Link
RUN ln -s /etc/apache2/sites-available/glpi.conf /etc/apache2/sites-enabled/glpi.conf
