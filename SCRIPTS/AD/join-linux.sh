#!/bin/bash

team=$1
ad=$2

echo "Attaching $HOSTNAME to ad.team$team.isucdc.com at ip:$ad"

read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

sudo apt-get install -y realmd libnss-sss libpam-sss sssd sssd-tools adcli samba-common-bin oddjob-mkhomedir packagekit

sudo hostnamectl set-hostname $HOSTNAME.team$team.isucdc.com
echo "New hostname $HOSTNAME"

sudo systemctl disable systemd-resolved.service
sudo systemctl stop systemd-resolved.service

cp /etc/resolv.conf /etc/resolv.conf.old

sed -i "s/^nameserver .*/nameserver $ad/" /etc/resolv.conf

realm discover ad.team$team.isucdc.com

echo "^^IF NO ACTIVE DIRECTORY ABOVE THIS LINE SOMETHING WENT WRONG!!^^"

echo "prepare to enter the password for Administrator on AD. Usualy something like CDC or password"

sudo realm join -U Administrator ad.team$team.isucdc.com

echo "running realm list. If the active directory doesnt show up please fix errors"

realm list

echo "You should now make a snapshot of this machine!!\nContinue to set up authentication"
