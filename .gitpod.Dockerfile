FROM gitpod/workspace-full:latest

USER gitpod

# Update
RUN sudo apt-get update -y
# Change your version here
RUN sudo update-alternatives --set php $(which php8.0)
#Install Xdebug
RUN sudo install-packages php8.0-xdebug -y && sudo apt autoremove -y

#Custom apache configuration
COPY --chown=gitpod:gitpod webserver/apache2/glpi.conf /etc/apache2/sites-available/glpi.conf

#Custom xdebug configuration
RUN sudo mv /etc/php/8.0/cli/conf.d/20-xdebug.ini /etc/php/8.0/cli/conf.d/20-xdebug.ini.bkp
COPY --chown=gitpod:gitpod webserver/xdebug/xdebug.ini /etc/php/8.0/cli/conf.d/xdebug.ini
COPY --chown=gitpod:gitpod webserver/xdebug/xdebug.ini /etc/php/8.0/mods-available/xdebug.ini

#Simbolic Link
RUN ln -s /etc/apache2/sites-available/glpi.conf /etc/apache2/sites-enabled/glpi.conf

