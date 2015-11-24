#!/bin/bash

#  ng_build.sh
#  
#
#  Created by Theodore Darling on 11/23/15.
#

# If NGINX is already installed, stop it
if ! which nginx > /dev/null 2>&1
then
    echo "Stopping existing NGINX service."
    sudo systemctl stop nginx
fi

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

nginx_folder="nginx-$nginx_version"
nginx_file="$nginx_folder.tar.gz"
nginx_url="nginx.org/download/$nginx_file"

cache_purge_folder="ngx_cache_purge-$cache_purge_version"
cache_purge_file="$cache_purge_folder.tar.gz"
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
wget "$cache_purge_url"

echo "Extracting build files"
sudo tar -xvzf "$nginx_file"
sudo tar -xvzf "$cache_purge_file"

echo "Moving to NGINX build folder"
cd "$nginx_folder"


# Install dependencies
echo "Install NGINX build dependencies"
sudo yum -y install gc gcc gcc-c++ pcre-devel zlib-devel make wget openssl-devel libxml2-devel libxslt-devel gd-devel perl-ExtUtils-Embed GeoIP-devel gperftools gperftools-devel libatomic_ops-devel perl-ExtUtils-Embed

echo "Configure NGINX build"
./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user="$nginx_user" --group="$nginx_user" --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-mail --with-mail_ssl_module --with-file-aio --with-ipv6 --with-threads --with-stream --with-stream_ssl_module --with-http_v2_module --with-cc-opt='-O2 -g -pipe -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic' --add-module="../$cache_purge_folder"

echo "Making NGINX build"
make && sudo make install

sudo wget -O /lib/systemd/system/nginx.service https://raw.githubusercontent.com/teddarling/cent-os-7.1-nginx-wordpress/master/nginx/nginx.service

# Setup some directories that are needed.
sudo mkdir -p /var/cache/nginx
sudo chown nginx /var/cache/nginx

# Create a directory for a default website
sudo mkdir -p /var/www/default/public_html

# Copy files from Web directory created by build to default dir
sudo cp -R /etc/nginx/html/* /var/www/default/public_html

# Reload some daemons
sudo systemctl daemon-reload

echo "Starting NGINX service and setting up auto start."
sudo systemctl start nginx
sudo systemctl enable nginx

echo "Returning the the start directory $start_dir"
cd "$start_dir"


# Remove the build directory, it's no longer needed.
echo "Build complete. Removing the build directory"
# Hide for now so that we can manually inspect the directories while testing out this script.
#sudo rm -rf "$build_folder"
