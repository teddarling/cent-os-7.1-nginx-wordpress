#!/bin/bash

#  install_php.sh
#  
#
#  Created by Theodore Darling on 11/24/15.
#

# Test if EPEL 7.5 is installed. If not, then install it.
if [ "$epel_version" != "epel-release-7-5.noarch" ]; then
    echo "Adding newer repo and updating"
    sudo rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
    sudo yum -y update
else
    echo "EPEL Installed"
fi