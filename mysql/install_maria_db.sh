#!/bin/bash

#  install_maria_db.sh
#  
#
#  Created by Theodore Darling on 11/25/15.
#

echo -e "Enter the password you wish to use for root"
read maria_password

# Install MariaDB if it isn't already installed.
if ! which mysql > /dev/null 2>&1
then
    sudo wget -O /etc/yum.repos.d/MariaDB.repo https://raw.githubusercontent.com/teddarling/cent-os-7.1-nginx-wordpress/master/MariaDB.repo

    sudo yum -y update

    echo "Installing MariaDB"
    sudo yum -y install mariadb-server mariadb

    # Start MariaDB and setup to start on reboot.
    echo "Starting MySQL and enabling for start at reboot"
    sudo systemctl start mysql
    sudo systemctl enable mysql

    # Secure MariaDB
    echo "Preparing to secure MySQL"
    echo "`curl -s https://raw.githubusercontent.com/teddarling/cent-os-7.1-nginx-wordpress/master/mysql/secure_maria_db.sh | sudo bash -s -- -m $maria_password -`"
else
    echo "Maria DB is already installed"
fi