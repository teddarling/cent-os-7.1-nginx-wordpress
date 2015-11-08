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

echo -e "Enter your install path and press [ENTER] (Blank for current directory): "
read wp_path

echo "Entered Path is $wp_path"

if [ -z "${wp_path}" ]; then
echo "VAR is unset or set to the empty string"
fi
if [ -z "${wp_path+set}" ]; then
echo "VAR is unset"
fi
if [ -z "${wp_path-unset}" ]; then
echo "VAR is set to the empty string"
fi
if [ -n "${wp_path}" ]; then
echo "VAR is set to a non-empty string"
fi
if [ -n "${wp_path+set}" ]; then
echo "VAR is set, possibly to the empty string"
fi
if [ -n "${wp_path-unset}" ]; then
echo "VAR is either unset or set to a non-empty string"
fi

#echo "Path is $wp_path"
