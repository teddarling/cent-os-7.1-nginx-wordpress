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
fi on 11/24/15.
#

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

# Install Webtatic PHP
