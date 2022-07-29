#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
TMPDIR=$(mktemp -d)
SOCKSDIR=/opt/socks
apt-get remove -y docker docker-engine docker.io containerd runc man-db
apt autoremove
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git \
    htop \
    ncdu \
    apache2 \
    php \
    libapache2-mod-php\
    php-mysql \
    wget
systemctl restart apache2

cd /var/www/html
wget http://wordpress.org/latest.tar.gz
tar xfz latest.tar.gz 
mv wordpress/* ./
rm -f latest.tar.gz
rm index.html
