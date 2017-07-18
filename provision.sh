#!/bin/bash

set -e

sudo yum update -y

# setup bind
sudo yum -y install bind bind-utils

# set bind files
sudo cp /etc/named.conf /etc/named.conf.ori
sudo cp /vagrant/cfg_files/bind/named.conf /etc/named.conf
sudo chown root:named /etc/named.conf
sudo cp /vagrant/cfg_files/bind/zones/* /var/named/
sudo chown root:named /var/named/net06.*
sudo /etc/init.d/named restart

# setup ntp

sudo yum -y install ntp

if [ -e /etc/ntp.conf ]; then
  sudo cp /etc/ntp.conf /etc/ntp.conf.ori
fi
sudo cp /vagrant/cfg_files/ntp/ntp.conf /etc/ntp.conf
sudo ntpdate ntp.nict.jp
sudo /etc/rc.d/init.d/ntpd start
sudo chkconfig ntpd on
chkconfig --list

