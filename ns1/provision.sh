#!/bin/bash

set -e

now=$(date +"%Y%m%d_%H_%M_%S")

if [ -e /vagrant ]; then
  WORKDIR='/vagrant'
else
  WORKDIR=$(pwd)
fi

sudo yum update -y

# setup bind
sudo yum -y install bind bind-utils

# set bind files
sudo cp /etc/named.conf /etc/named.conf.$now
sudo cp $WORKDIR/cfg_files/bind/named.conf /etc/named.conf
sudo chown root:named /etc/named.conf
sudo cp $WORKDIR/cfg_files/bind/zones/* /var/named/
sudo chown root:named /var/named/net06.*
# update root zone
sudo dig . ns @198.41.0.4 > /var/named/named.ca
sudo chkconfig named on
sudo /etc/init.d/named restart

# setup ntp

sudo yum -y install ntp

if [ -e /etc/ntp.conf ]; then
  sudo cp /etc/ntp.conf /etc/ntp.conf.$now
fi
sudo cp $WORKDIR/cfg_files/ntp/ntp.conf /etc/ntp.conf
sudo /etc/init.d/ntpd stop
sudo ntpdate ntp.nict.jp
sudo /etc/init.d/ntpd start
sudo chkconfig ntpd on
chkconfig --list

# setup postfix

sudo yum -y install postfix cyrus-sasl
sudo chkconfig saslauthd on
if [ -e /etc/postfix/main.cf ]; then
  sudo cp /etc/postfix/main.cf /etc/postfix/main.cf.$now
fi
sudo cp $WORKDIR/cfg_files/postfix/main.cf /etc/postfix/main.cf
if [ -e /etc/postfix/master.cf ]; then
  sudo cp /etc/postfix/master.cf /etc/postfix/master.cf.$now
fi
sudo cp $WORKDIR/cfg_files/postfix/master.cf /etc/postfix/master.cf

sudo /etc/rc.d/init.d/saslauthd start

sudo echo unknown_user: /dev/null >> /etc/aliases
sudo newaliases

sudo postconf -d > postfix_setting_$now.log
sudo /etc/rc.d/init.d/postfix restart

# setup dovecot
sudo yum -y install dovecot

sudo cp $WORKDIR/cfg_files/dovecot/dovecot.conf /etc/dovecot/dovecot.conf
sudo cp $WORKDIR/cfg_files/dovecot/10-auth.conf /etc/dovecot/conf.d/10-auth.conf
sudo cp $WORKDIR/cfg_files/dovecot/10-mail.conf /etc/dovecot/conf.d/10-mail.conf
sudo cp $WORKDIR/cfg_files/dovecot/10-master.conf /etc/dovecot/conf.d/10-master.conf
sudo cp $WORKDIR/cfg_files/dovecot/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf

sudo chkconfig dovecot on
sudo /etc/rc.d/init.d/dovecot start

# setup dhcp
yum -y install dhcp
sudo cp $WORKDIR/cfg_files/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf
sudo /etc/rc.d/init.d/dhcpd start

