#!/bin/bash

set -e

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

# setup dovecot
sudo yum -y install dovecot

if [ -e /etc/dovecot/dovecot.conf ]; then
  sudo cp /etc/dovecot/dovecot.conf /etc/dovecot/dovecot.conf.$now
fi
sudo cp $WORKDIR/cfg_files/dovecot/10-auth.conf /etc/dovecot/conf.d/10-auth.conf
sudo cp $WORKDIR/cfg_files/dovecot/10-mail.conf /etc/dovecot/conf.d/10-mail.conf
sudo cp $WORKDIR/cfg_files/dovecot/10-master.conf /etc/dovecot/conf.d/10-master.conf
sudo cp $WORKDIR/cfg_files/dovecot/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf

sudo chkconfig dovecot on
sudo /etc/rc.d/init.d/dovecot start

# setup dhcp
yum -y install dhcp
if [ -e /etc/dhcp/dhcpd.conf ]; then
  sudo cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.$now
fi
sudo cp $WORKDIR/cfg_files/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf
sudo /etc/rc.d/init.d/dhcpd start

