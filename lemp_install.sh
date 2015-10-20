#!/bin/sh

#  lemp_install.sh
#  
#
#  Created by Theodore Darling on 10/20/15.
#
# This is a basic install of NGINX, PHP and MariaDB (MySQL)
# using some good sources of repos with more current installs.
# This is all yum based at this point.
#
# Using Yum as it sets up some users and directories that will be needed
# for more advanced usage. It's easier to let this go through Yum now,
# instead of trying to do everything by hand. (See build_ng.sh)

usage()
{
cat << EOF
    usage: $0 options

    This script will download the expected version of NGINX and NGINX_Cache_purge to the folder specified and build it with the correct user

    OPTIONS:
        -h      Show this message
        -m      Password for MariaDB (MySQL)
        ?       Show this message
EOF
}

# Parse the arguments
while getopts "hm:" OPTION
do
    case $OPTION in
        h)
            usage
            exit 1
            ;;
        m) # MariaDB Password
            maria_password="$OPTARG"
            ;;
        ?)
            usage
            exit 1
            ;;
    esac
done

# If empty arguments given, show usage of script
if [[ -z "$maria_password" ]]
then
    usage
    exit 1
fi

# Load some new Yum repositories
echo "Adding some required repos and updating Yum"
rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

sudo wget -O /etc/yum.repos.d/MariaDB.repo https://raw.githubusercontent.com/teddarling/cent-os-7.1-nginx-wordpress/master/MariaDB.repo

sudo yum -y update

# Install NGINX if it isn't already installed.
if ! which nginx > /dev/null 2>&1
then
    echo "Installing NGINX"

    sudo yum -y install nginx

    echo "Starting NGINX"
    sudo systemctl start nginx

    echo "Adding NGINX to start on boot"
    sudo systemctl enable nginx
else
    echo "NGINX already installed"
fi

# Install MariaDB if it isn't already installed.
if ! which mysql > /dev/null 2>&1
then
    echo "MySQL not installed"
else
    echo "MySQL installed"
fi



# Install PHP-FPM if it isn't already installed.
if ! which php-fpm > /dev/null 2>&1
then
    echo "PHP-FPM not installed"
else
    echo "PHP-FPM installed"
fi


