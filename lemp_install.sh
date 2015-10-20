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