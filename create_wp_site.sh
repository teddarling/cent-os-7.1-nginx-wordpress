#!/bin/sh

#  create_wp_site.sh
#  
#
#  Created by Ted Darling on 11/8/15.
#
#  What is wanted here is a simple way for me to create new websites
#  on a server at any point in time for the logged in user. The logged
#  in user will need to have sudo privileges. This is script is probably
#  more specific to my own needs than to others, but is provided to
#  others so that they can use and/or modify as needed.
#
#  Start by assuming that the user just wants to install WordPress to a
#  directory on their server. Along the way, check that pre-requisites are
#  installed. If they aren't, call some other scripts to install them.
#
#  So here is what we want to do when we want to create a new WordPress site.
#
#  1) Set the domain name of the site. Using this name, create the following
#      a) domain_name.conf in /etc/nginx/conf.d folder
#      b) create folder in /usr/share/nginx folder based on the domain name

echo -e "Enter your domain name and press [ENTER]: "
read wp_domain

#  Set the path to the current directory if the user didn't enter anything
while [ "$wp_path" != '' ]; do
    read wp_domain
done

echo "Domain is $wp_domain"
