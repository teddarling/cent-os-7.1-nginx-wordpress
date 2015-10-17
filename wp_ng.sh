#!/bin/bash

# Build directory that we are going to work with.
BUILD_DIR="wp_ng"
NGINX_VERSION="nginx-1.8.0"
NGINX_FILE="$NGINX_VERSION.tar.gz"
NGINX_URL="nginx.org/download/$NGINX_FILE"


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

# Download NGINX, if the file doesn't exist.
if [ ! -f "$NGINX_FILE" ]; then
  echo "Downloading nginx from ($NGINX_URL)"
  wget "$NGINX_URL"
fi

# Create the nginx user if it doesn't exist
if ! id -u nginx >/dev/null 2>&1; then
  echo "Adding nginx user"
  useradd nginx
  usermod -s /sbin/nologin nginx
fi