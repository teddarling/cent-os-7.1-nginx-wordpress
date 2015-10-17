#!/bin/sh

#  build_ng.sh
#  
#
#  Created by Theodore Darling on 10/16/15.
#

# Message to display if no valid arguments
usage()
{
cat << EOF
  usage: $0 options

  This script will download the expected version of NGINX and NGINX_Cache_purge to the folder specified and build it with the correct user

  OPTIONS:
    -h      Show this message
    -c      NGINX cache purge version to build(EX: 2.3)
    -d      Directory to download and build NGINX
    -n      NGINX version (EX: 1.8.0)
    -u      User to create for NGINX
    ?       Show this message
EOF
}

# Parse the arguments
while getopts "hc:d:n:u:" OPTION
do
  case $OPTION in
    h)
      usage
      exit 1
      ;;
    c)  # version of Cache Purge to build.
      cache_purge_version="ngx_cache_purge-$OPTARG"
      ;;
    d)  # Directory to build in.
      build_dir="$OPTARG"
      ;;
    n) # Version of NGINX to download.
      nginx_version="nginx-$OPTARG"
      ;;
    u) # User to assign to the build
      nginx_user="$OPTARG"
;;
    ?)
      usage
      exit 1
      ;;
  esac
done

# If empty arguments given, show usage of script
if [[ -z "$build_dir" ]] || [[ -z "$nginx_version" ]] || [[ -z "$cache_purge_version" ]] || [[ -z "$nginx_user" ]]
then
  usage
  exit 1
fi

# Assign some values for files and URLs on NGINX and cache purge
nginx_file="$nginx_version.tar.gz"
nginx_url="nginx.org/download/$nginx_file"

cache_purge_file="$cache_purge_version.tar.gz"
cache_purge_url="labs.frickle.com/files/$cache_purge_file"

# Add the latest version of the repo
rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

# Update Yum
echo "Update Yum"
sudo yum -y update

# Install dependencies
echo "Install NGINX build dependencies"
sudo yum -y install gc gcc gcc-c++ pcre-devel zlib-devel make wget openssl-devel libxml2-devel libxslt-devel gd-devel perl-ExtUtils-Embed GeoIP-devel gperftools gperftools-devel libatomic_ops-devel perl-ExtUtils-Embed

# Create the nginx user if it doesn't exist
if ! id -u nginx >/dev/null 2>&1; then
  echo "Adding nginx user"
  useradd "$nginx_user"
  usermod -s /sbin/nologin "$nginx_user"
fi

# Delete the build directory and start from scratch
sudo rm -rf $build_dir

# Create the build dir.
echo "Create build directory: $build_dir"
mkdir -pv $build_dir

# go to the build directory
echo "Move to build directory: $build_dir"
cd "$build_dir"



echo "$nginx_file"
echo "$cache_purge_url"
