#!/bin/bash

#  ng_build.sh
#  
#
#  Created by Theodore Darling on 11/23/15.
#

start_dir=$(pwd)
echo "Setting start directory $start_dir"

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

echo "Checking for wget, if not found, install it."
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

echo -e "Enter a name for your build folder"
read build_folder

echo -e "Enter the username for your NGINX user"
read nginx_user


nginx_file="nginx-$nginx_version.tar.gz"
nginx_url="nginx.org/download/$nginx_file"

cache_purge_file="ngx_cache_purge-$cache_purge_version.tar.gz"
cache_purge_url="labs.frickle.com/files/$cache_purge_file"

echo "Preparing to download NGINX from $nginx_url and cache purge from $cache_purge_url"

# Create a build folder and move into it.
echo "Creating build folder"
mkdir -p "$build_folder"
cd "$build_folder"

echo "Moved to folder $(pwd)"

# Create the nginx user if it doesn't exist
if ! id -u "$nginx_user" >/dev/null 2>&1; then
    echo "Adding user $nginx_user"
    useradd "$nginx_user"
    usermod -s /sbin/nologin "$nginx_user"
fi

echo "Downloading build files"
wget "$nginx_url"
wget "$cache_purge_file"

echo "Extracting build files"
sudo tar -xvzf "$nginx_file"
sudo tar -xvzf "$cache_purge_file"


echo "Returning the the start directory $start_dir"
cd "$start_dir"


# Remove the build directory, it's no longer needed.
echo "Build complete. Removing the build directory"
# Hide for now so that we can manually inspect the directories while testing out this script.
#sudo rm -rf "$build_folder"
