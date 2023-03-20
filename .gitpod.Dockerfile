FROM gitpod/workspace-full:latest

USER gitpod

#Install Xdebug
RUN sudo install-packages php-xdebug

#Custom apache configuration
COPY webserver/apache2/glpi.conf /etc/apache2/sites-available/glpi.conf

#Simbolic Link
RUN ln -s /etc/apache2/sites-available/glpi.conf /etc/apache2/sites-enabled/glpi.conf
