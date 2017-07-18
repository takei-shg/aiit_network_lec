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

# setup postfix

sudo yum -y install postfix cyrus-sasl
sudo chkconfig saslauthd on
if [ -e /etc/postfix/main.cf ]; then
  sudo cp /etc/postfix/main.cf /etc/postfix/main.cf.ori
fi
sudo cp /vagrant/cfg_files/postfix/main.cf /etc/postfix/main.cf
if [ -e /etc/postfix/master.cf ]; then
  sudo cp /etc/postfix/master.cf /etc/postfix/master.cf.ori
fi
sudo cp /vagrant/cfg_files/postfix/master.cf /etc/postfix/master.cf

sudo /etc/rc.d/init.d/saslauthd start

sudo echo unknown_user: /dev/null >> /etc/aliases
sudo newaliases

sudo postconf -d > postfix_setting.log
sudo /etc/rc.d/init.d/postfix restart
