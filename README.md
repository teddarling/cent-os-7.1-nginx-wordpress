# Setup NGINX on new CentOS 7.1 Server

This is a process that I have handled now on at least 3 occassions. Based on that, it's time to automate it a little. Besides, It seems to take me several hours to hunt down everything all the time as I am a developer, rather than a sys admin. But I love this setup, it works well and I this also helps me remember how to set it up.

## Build NGINX

You can either download scripts directly and run them on your server, or use some one liners to get these to run. This is how I run this script to setup NGINX with Cache Purge. The only way to get Cache Purge to work with NGINX on CentOS (Probably on RedHat as well) is to do a custom NGINX build.

```bash
curl -s https://raw.githubusercontent.com/teddarling/cent-os-7.1-nginx-wordpress/master/build_ng.sh | sudo bash -s -- -c "2.3" -d build_ng -n "1.8.0" -u nginx -
```

- update

## Install MariaDB

## Install HHVM

Tutorial on setting up CentOS 7.1 with NGINX and WordPress A place to keep my steps in one place along with setting up a shell script so that it can be done again.
