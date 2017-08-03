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

if [ -e /etc/dovecot ]; then
  sudo cp -r /etc/dovecot /etc/dovecot.$now
fi
sudo cp $WORKDIR/cfg_files/dovecot/* /etc/dovecot/conf.d/

sudo chkconfig dovecot on
sudo /etc/rc.d/init.d/dovecot start

# setup dhcp
yum -y install dhcp
if [ -e /etc/dhcp/dhcpd.conf ]; then
  sudo cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.$now
fi
sudo cp $WORKDIR/cfg_files/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf
sudo /etc/rc.d/init.d/dhcpd start

