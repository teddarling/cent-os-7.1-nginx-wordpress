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
        -u      User to create for NGINX
        ?       Show this message
EOF
}

# Parse the arguments
while getopts "hu:" OPTION
do
    case $OPTION in
        h)
            usage
            exit 1
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
if [[ -z "$nginx_user" ]]
then
    usage
    exit 1
fi

# Install MariaDB from yum
echo 'Securing MariaDB'