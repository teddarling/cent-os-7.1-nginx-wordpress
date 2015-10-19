#!/bin/sh

#  install_maria_db.sh
#  
#
#  Created by Theodore Darling on 10/19/15.
#


# Message to display if no valid arguments
usage()
{
cat << EOF
    usage: $0 options

    This script will download the expected version of NGINX and NGINX_Cache_purge to the folder specified and build it with the correct user

    OPTIONS:
        -h      Show this message
        -m      User to create for MariaDB
        ?       Show this message
EOF
}

# Parse the arguments
while getopts "hm:p:" OPTION
do
    case $OPTION in
        h)
            usage
            exit 1
            ;;
        m) # User to assign to the build
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

# Install MariaDB from yum
echo 'Securing MariaDB'
sudo yum -y install expect


