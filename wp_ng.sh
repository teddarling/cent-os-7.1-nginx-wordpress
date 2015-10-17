#!/bin/bash

# Build directory that we are going to work with.
BUILD_DIR="wp_ng"
NGINX_VERSION="nginx-1.8.0"
NGINX_FILE="$NGINX_VERSION.tar.gz"


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
echo "Install wget"
sudo yum -y install wget

# Download NGINX
echo "Downloading NGINX from ($NGINX_FILE)"
wget "nginx.org/download/$NGINX_FILE"

# Create the nginx user if it doesn't exist
if ! id -u nginx >/dev/null 2>&1; then
  echo "Adding nginx user"
  useradd nginx
  usermod -s /sbin/nologin nginx
fi