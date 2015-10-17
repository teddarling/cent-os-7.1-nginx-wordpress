#!/bin/bash

# Build directory that we are going to work with.
BUILD_DIR="$HOME/wp_ng"

# If the build directory doesn't exist, create it
if [ ! -d "$BUILD_DIR" ]; then
  echo "Create build directory"
  mkdir -pv $BUILD_DIR
fi

# move to the build directory
echo "Move to build directory"
cd $BUILD_DIR

# Download NGINX
wget nginx.org/download/nginx-1.8.0.tar.gz

# Create the nginx user if it doesn't exist
if ! id -u nginx >/dev/null 2>&1; then
  echo "Adding nginx user"
  useradd nginx
  usermod -s /sbin/nologin nginx
fi