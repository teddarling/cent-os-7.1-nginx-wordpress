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
#
#  2) Enter a title for the site.
#
#  3) Enter an admin username, admin is not an option (security reasons).
#
#  4) Enter an admin email address.
#
#  5) Enter the admin password.
#
#  6) Enter the database name.
#
#  7) Enter the database user.
#
#  8) Enter the database password.
#
#  9) Enter the database host (default localhost).
#
#  10) Enter the database prefix (default wp_)
#
#  11)

echo -e "Enter your domain name and press [ENTER]: "
read wp_domain

#  Set the path to the current directory if the user didn't enter anything
while [[ -z "$wp_domain" ]]; do
    echo -e "Blank is not an option. Please enter your domain name and press [ENTER]: "
    read wp_domain
done

echo "Domain is $wp_domain"

site_conf="/etc/nginx/conf.d/$wp_domain.conf"

# Copy the config file for this domain into a conf file for NGINX
sudo wget -O "$site_conf" https://raw.githubusercontent.com/teddarling/cent-os-7.1-nginx-wordpress/master/wp/site_template.conf

# Change the name of the
sudo sed -i 's/replace_server/'$wp_domain'/g' "$site_conf"

# Create the public_html directory for the domain entered
sudo mkdir -p "/var/www/$wp_domain/public_html"


# Create the log directory for the name
sudo mkdir -p "/var/www/$wp_domain/logs"

