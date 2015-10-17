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
  mkdir -pv $BUILD_DIR
fi

# move to the build directory
echo "Move to build directory: $BUILD_DIR"
cd $BUILD_DIR

# Update Yum
echo "Update Yum"
sudo yum -y update

# Install wget
if ! sudo yum list installed wget; then
  echo "Install wget"
  sudo yum -y install wget
fi

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

# If the nginx directory for extraction exists, delete it.
if [ -d "$NGINX_VERSION" ]; then
  echo "Removing NGINX directory"
  sudo rm -rf "$NGINX_VERSION"
fi

# Extract the NGINX file.
echo "Extracting NGINX"
tar -xvzf $NGINX_FILE

# Download NGINX cache purge, if the file doesn't exist.
if [ ! -f "$NGINX_CACHE_PURGE_FILE" ]; then
  echo "Downloading nginx cache purge from ($NGINX_CACHE_PURGE_URL)"
  wget "$NGINX_CACHE_PURGE_URL"
fi

# If the nginx cache purge directory for extraction exists, delete it.
if [ -d "$NGINX_CACHE_PURGE_VERSION" ]; then
  echo "Removing NGINX cache purge directory"
  sudo rm -rf "$NGINX_CACHE_PURGE_VERSION"
fi

# Extract the NGINX cache purge file.
echo "Extracting NGINX cache purge"
tar -xvzf $NGINX_CACHE_PURGE_FILE

# move to the directory created by extracting the NGINX file.
echo "Move to NGINX directory"
cd "$NGINX_VERSION"

sudo ls -la