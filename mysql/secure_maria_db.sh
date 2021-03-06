#!/bin/bash

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
while getopts "hm:" OPTION
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

echo "Run mysql_secure_installation"

SECURE_MYSQL=$(expect -c "

set timeout 10
spawn mysql_secure_installation

expect \"Enter current password for root (enter for none):\"
send \"\r\"

expect \"Change the root password?\"
send \"y\r\"

expect \"New password:\"
send \"$maria_password\r\"

expect \"Re-enter new password:\"
send \"$maria_password\r\"

expect \"Remove anonymous users?\"
send \"y\r\"

expect \"Disallow root login remotely?\"
send \"y\r\"

expect \"Remove test database and access to it?\"
send \"y\r\"

expect \"Reload privilege tables now?\"
send \"y\r\"

expect eof
")

echo "$SECURE_MYSQL"


