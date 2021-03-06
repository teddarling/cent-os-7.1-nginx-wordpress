#!/bin/bash

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

# Move these errors to the top, why mess with everything else otherwise.
# If php isn't installed, then wp command won't work, so set an error.
if ! which php-fpm > /dev/null 2>&1
then
    echo "Please ensure that PHP is installed or in your path."
    exit 1
fi

# If mysql isn't installed, then wp config won't work, so set an error.
if ! which mysql > /dev/null 2>&1
then
    echo "Please ensure that a mysql client is installed or in your path."
    exit 1
fi


echo -e "Enter your domain name and press [ENTER]: "
read wp_domain

#  Set the path to the current directory if the user didn't enter anything
while [[ -z "$wp_domain" ]]; do
    echo -e "Blank is not an option. Please enter your domain name and press [ENTER]: "
    read wp_domain
done

echo "Setting up the configuration for $wp_domain"

site_conf="/etc/nginx/conf.d/$wp_domain.conf"

# Copy the config file for this domain into a conf file for NGINX
sudo wget -O "$site_conf" https://raw.githubusercontent.com/teddarling/cent-os-7.1-nginx-wordpress/master/wp/site_template.conf

# If shared WP config file doesn't exist, copy it to server.
echo "Checking for /etc/nginx/wp.conf"
if [[ ! -f /etc/nginx/wp.conf ]]
then
    echo "Copying shared wp.conf file to server."
    sudo wget -O /etc/nginx/wp.conf https://raw.githubusercontent.com/teddarling/cent-os-7.1-nginx-wordpress/master/wp/wp.conf
fi

# Change the name of the
echo "Replacing text with domain name"
sudo sed -i 's/replace_server/'$wp_domain'/g' "$site_conf"

site_dir="/var/www/$wp_domain/public_html"

# Create the public_html directory for the domain entered
echo "Creating web folder for $wp_domain"
sudo mkdir -p "$site_dir"

# Set owner of site directory to nginx
echo "Changing ownership of $site_dir"
sudo chown -R nginx:nginx "$site_dir"

# Create the log directory for the name
sudo mkdir -p "/var/www/$wp_domain/logs"

# Set security context for httpd
sudo semanage fcontext --add --type httpd_sys_content_t "/var/www/$wp_domain(/.*)?"
sudo restorecon -Rv /var/www

# Get the title of the site (used by WordPress.
echo -e "Enter a title for your site (Default is the $wp_domain)"
read site_title

if [[ -z "$site_title" ]]; then
    site_title="$wp_domain"
fi

# Get a username for the site. Disallow 'admin' as it lowers security.
echo -e "Enter the username for your site (DO NOT USE admin)"
read site_username

while [[ -z "$site_username" || ("admin" == "$site_username") ]]; do
    echo -e "Invalid Entry. Please enter the username for your site (DO NOT USE admin)"
    read site_username
done

# Get an email for the admin user.
echo -e "Enter the email address of the admin user"
read site_email

while [[ -z "$site_email" ]]; do
    echo -e "Invalid Entry. Please enter the email for the admin user"
    read Enter
done

# Get an email for the admin user.
echo -e "Enter the password for the admin user"
read site_password

while [[ -z "$site_password" ]]; do
    echo -e "Invalid Entry. Please enter the password for the admin user"
    read site_password
done

# Get database data so that we can setup the db
echo -e "Enter the database host (Default localhost) for this site"
read db_host

if [[ -z "$db_host" ]]; then
    db_host="localhost"
fi



# Get the database name for this site.
echo -e "Enter the database name for this site"
read db_name

while [[ -z "$db_name" ]]; do
    echo -e "Invalid Entry. Enter the database name for this site"
    read db_name
done

# Get the database name for this site.
echo -e "Enter the database prefix for this site (default wp_)"
read db_prefix

# Set db_prefix to WordPress default of wp_ if user didn't enter anything.
if [[ -z "$db_prefix" ]]; then
    db_prefix="wp_"
fi


# Get an email for the admin user.
echo -e "Enter the database user for this site"
read db_user

while [[ -z "$db_user" ]]; do
    echo -e "Invalid Entry. Enter the database user for this site"
    read db_user
done

# Get an email for the admin user.
echo -e "Enter the database password for this site"
read db_pass

while [[ -z "$db_pass" ]]; do
    echo -e "Invalid Entry. Enter the database password for this site"
    read db_pass
done

# Check if WP CLI installed, if not, install it.
echo "Checking for wpcli, if not found, install it."
if ! which wp > /dev/null 2>&1
then
    echo "Installing WP CLI"
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli-nightly.phar
    chmod +x wp-cli-nightly.phar
    sudo mv wp-cli-nightly.phar /usr/sbin/wp
fi

echo "Moving to WordPress install dir $site_dir"
cd "$site_dir"

echo $(pwd)

echo "Downloading and setting up WordPress"
sudo -u nginx wp core download
sudo -u nginx wp core config --dbname="$db_name" --dbuser="$db_user" --dbpass="$db_pass" --dbhost="$db_host" --dbprefix="$db_prefix"

sudo -u nginx wp core install --url="$wp_domain" --title="$site_title" --admin_user="$site_username" --admin_password="$site_password" --admin_email="$site_email"



# Restart nginx so that we can access the site.
echo "Restarting NGINX."
sudo systemctl restart nginx

