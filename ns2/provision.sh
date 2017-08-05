#!/bin/bash

set -ex

now=$(date +"%Y%m%d_%H_%M_%S")

if [ -e /vagrant ]; then
  WORKDIR='/vagrant'
else
  WORKDIR=$(pwd)
fi

sudo yum update -y

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

if [ -e /etc/dovecot ]; then
  sudo cp -r /etc/dovecot /etc/dovecot.$now
fi
sudo cp $WORKDIR/cfg_files/dovecot/dovecot.conf /etc/dovecot/dovecot.conf
sudo cp $WORKDIR/cfg_files/dovecot/conf.d/* /etc/dovecot/conf.d/

sudo chkconfig dovecot on
sudo /etc/rc.d/init.d/dovecot start

# setup dhcp
yum -y install dhcp
if [ -e /etc/dhcp/dhcpd.conf ]; then
  sudo cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.$now
fi
sudo cp $WORKDIR/cfg_files/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf
sudo /etc/rc.d/init.d/dhcpd start

