#!/bin/bash

# Build directory that we are going to work with.
BUILD_DIR="wp_ng"
NGINX_VERSION="nginx-1.8.0"
NGINX_FILE="$NGINX_VERSION.tar.gz"
NGINX_URL="nginx.org/download/$NGINX_FILE"

NGINX_CACHE_PURGE_VERSION="ngx_cache_purge-2.3"
NGINX_CACHE_PURGE_FILE="$NGINX_CACHE_PURGE_VERSION.tar.gz"
NGINX_CACHE_PURGE_URL="labs.frickle.com/files/$NGINX_CACHE_PURGE_FILE"


# If the build directory doesn't exist, create it
if [ ! -d "$BUILD_DIR" ]; then
  echo "Create build directory"
  mkdir -pv "$BUILD_DIR"
fi

# move to the build directory
echo "Move to build directory: $BUILD_DIR"
cd "$BUILD_DIR"

# Update some repos
rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

# Update Yum
echo "Update Yum"
sudo yum -y update

# Install wget, will continue if already installed
echo "Install wget"
sudo yum -y install wget

# Install development tools
#sudo yum -y group install "Development Tools"
#sudo yum -y install pcre-devel zlib-devel openssl-devel
sudo yum -y install gc gcc gcc-c++ pcre-devel zlib-devel make wget openssl-devel libxml2-devel libxslt-devel gd-devel perl-ExtUtils-Embed GeoIP-devel gperftools gperftools-devel libatomic_ops-devel perl-ExtUtils-Embed

# Create the nginx user if it doesn't exist
if ! id -u nginx >/dev/null 2>&1; then
echo "Adding nginx user"
useradd nginx
usermod -s /sbin/nologin nginx
fi

# Download NGINX, if the file doesn't exist.
if [ ! -f "$NGINX_FILE" ]; then
  echo "Downloading nginx from ($NGINX_URL)"
  wget "$NGINX_URL"
fi

# Download NGINX cache purge, if the file doesn't exist.
if [ ! -f "$NGINX_CACHE_PURGE_FILE" ]; then
  echo "Downloading nginx cache purge from ($NGINX_CACHE_PURGE_URL)"
  wget "$NGINX_CACHE_PURGE_URL"
fi



# If the nginx directory for extraction exists, delete it.
if [ -d "$NGINX_VERSION" ]; then
  echo "Removing NGINX directory"
  sudo rm -rf "$NGINX_VERSION"
fi

# Extract the NGINX file.
echo "Extracting NGINX"
sudo tar -xvzf "$NGINX_FILE"

# Delete the NGINX file (don't need it anymore)
sudo rm -f "$NGINX_FILE"



# If the nginx cache purge directory for extraction exists, delete it.
if [ -d "$NGINX_CACHE_PURGE_VERSION" ]; then
  echo "Removing NGINX cache purge directory"
  sudo rm -rf "$NGINX_CACHE_PURGE_VERSION"
fi

# Extract the NGINX file.
echo "Extracting NGINX cache purge"
sudo tar -xvzf "$NGINX_CACHE_PURGE_FILE"

# Delete the NGINX cache purge file (don't need it anymore)
sudo rm -f "$NGINX_CACHE_PURGE_FILE"

# move to the directory created by extracting the NGINX file.
echo "Move to NGINX directory"
cd "$NGINX_VERSION"

sudo ls -la

./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-mail --with-mail_ssl_module --with-file-aio --with-ipv6 --with-http_spdy_module --with-cc-opt='-O2 -g -pipe -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic' --add-module=../$NGINX_CACHE_PURGE_VERSION

# Cleanup, remove anything installed by yum, or temporarily used to build NGINX. Consider doing this only if bash parameter passed when running script (for other people to use)