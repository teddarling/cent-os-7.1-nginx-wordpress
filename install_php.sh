#!/bin/sh

#  install_php.sh
#  
#
#  Created by Theodore Darling on 10/17/15.
#

# Get the yum repos needed for PHP 7
echo "Getting Repos"
rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

sudo yum -y update

# Install PHP 7 FPM
sudo yum -y --enablerepo=webtatic-testing install php70w php70w-opcache php70w-common php70w-bcmath php70w-cli php70w-fpm php70w-gd php70w-imap php70w-mbstring php70w-mcrypt php70w-mysqlnd php70w-odbc php70w-pgsql php70w-pspell php70w-soap php70w-tidy php70w-xml php70w-xmlrpc

# Change php.ini to work well with NGINX.
sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php.ini

# Change user for php-fpm
sudo sed -i 's/user = apache/user = nginx/' /etc/php-fpm.d/www.conf
sudo sed -i 's/group = apache/group = nginx/' /etc/php-fpm.d/www.conf
sudo sed -i 's/listen.owner = nobody/listen.owner = nginx/' /etc/php-fpm.d/www.conf
sudo sed -i 's/listen.group = nobody/listen.group = nginx/' /etc/php-fpm.d/www.conf

# Restart php and nginx
sudo systemctl restart php-fpm
sudo systemctl restart nginx

# Setup to start automatically on server reboot
sudo systemctl enable php-fpm