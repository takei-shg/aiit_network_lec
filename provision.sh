#!/bin/bash

set -e

sudo yum update -y
sudo yum -y install bind bind-utils

# set bind files
sudo cp /etc/named.conf /etc/named.conf.ori
sudo cp /vagrant/cfg_files/bind/named.conf /etc/named.conf
sudo chown root:named /etc/named.conf
sudo cp /vagrant/cfg_files/bind/zones/* /var/named/
sudo chown root:named /var/named/net06.*
sudo /etc/init.d/named restart

