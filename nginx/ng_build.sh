#!/bin/bash

#  ng_build.sh
#  
#
#  Created by Theodore Darling on 11/23/15.
#

epel_version=$(rpm -qa | grep "epel")
echo "EPEL VERSION: $epel_version"

echo "Adding newer repo and updating"
sudo rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
sudo yum -y update

echo "Checking for wget"
if ! which wget > /dev/null 2>&1
then
    echo "Installing wget"
    sudo yum -y install wget
fi

# Get the version of NGINX to download.
echo -e "Enter the version of NGINX that you would like to download and build"
read nginx_version

# Get the version of cache purge to download
echo -e "Enter the version of ngx_cache_purge that you wish to download and build"
read cache_purge_version


nginx_file="nginx-$nginx_version.tar.gz"
nginx_url="nginx.org/download/$nginx_file"

cache_purge_file="ngx_cache_purge-$cache_purge_version.tar.gz"
cache_purge_url="labs.frickle.com/files/$cache_purge_file"

echo "Preparing to download NGINX from $nginx_url and cache purge from $cache_purge_url"