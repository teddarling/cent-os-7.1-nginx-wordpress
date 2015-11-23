#!/bin/bash

#  ng_build.sh
#  
#
#  Created by Theodore Darling on 11/23/15.
#


echo "Adding newer repo and updating"
sudo rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
sudo yum -y update

echo "Checking for wget"
if ! which wget > /dev/null 2>&1
then
    echo "Installing wget"
    sudo yum -y install wget
fi

echo -e "Enter the version of NGINX that you would like to install"
read nginx_version

install_version="nginx-$nginx_version"

echo "Preparing to install NGINX Version $install_version"