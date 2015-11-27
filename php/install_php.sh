#!/bin/bash

#  install_php.sh
#  
#
#  Created by Theodore Darling on 11/24/15.
#

# Get the epel install version
epel_version=$(rpm -qa | grep "epel")
echo "EPEL VERSION: $epel_version"


# Test if EPEL 7.5 is installed. If not, then install it.
if [ "$epel_version" != "epel-release-7-5.noarch" ]; then
    echo "Adding newer repo and updating"
    sudo rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
    sudo yum -y update
else
    echo "EPEL Installed"
fi


# Get the epel install version
webtatic_version=$(rpm -qa | grep "webtatic")
echo "WEBTATIC VERSION: $webtatic_version"

# Test if Webtatic 7.3 is installed. If not, then install it.
if [ "$webtatic_version" != "webtatic-release-7-3.noarch" ]; then
    echo "Adding newer webtatic repo and updating"
    sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
    sudo yum -y update
else
    echo "Webtatic Installed"
fi

# Install PHP-FPM if it isn't already installed.
if ! which php-fpm > /dev/null 2>&1
then
    echo "Installing PHP-FPM"
    sudo yum -y install --enablerepo=webtatic-testing php70w php70w-mysql php70w-fpm php70w-cli php70w-common php70w-bcmath php70w-gd php70w-imap php70w-mbstring php70w-mbstring php70w-opcache php70w-pear php70w-pgsql php70w-pspell php70w-soap php70w-tidy php70w-xml php70w-xmlrpc


else
    echo "PHP-FPM installed"
fi

# Secure PHP a little here.
sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php.ini

# Change user for PHP
sudo sed -i 's/user = apache/user = nginx/' /etc/php-fpm.d/www.conf
sudo sed -i 's/group = apache/group = nginx/' /etc/php-fpm.d/www.conf

# Change session permissions from apache to nginx
sudo chown nginx:nginx /var/lib/php/session

# Setup PHP-FPM to use sockets for nginx
sed -i s'/listen = 127.0.0.1:9000/listen = \/var\/run\/php-main.socket/' /etc/php-fpm.d/www.conf
sed -i s'/;listen.owner = nobody/listen.owner = nginx/' /etc/php-fpm.d/www.conf
sed -i s'/;listen.group = nobody/listen.group = nginx/' /etc/php-fpm.d/www.conf
sed -i s'/;listen.mode = 0660/listen.mode = 0660/' /etc/php-fpm.d/www.conf

# Start and enable PHP-FPM
echo "Starting and enabling PHP-FPM"
sudo systemctl start php-fpm
sudo systemctl enable php-fpm

echo "Copying the PHP shared config file to nginx config folder"
sudo wget -O /etc/nginx/php.conf https://raw.githubusercontent.com/teddarling/cent-os-7.1-nginx-wordpress/master/php/php.conf