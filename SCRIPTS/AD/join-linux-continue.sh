#!/bin/bash

team=$1
ad=$2

echo "Attaching $HOSTNAME to ad.team$team.isucdc.com at ip:$ad"

read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

`sed -i "s/^Default:  .*/Default: yes/" /usr/share/pam-configs/mkhomedir`
`sed -i "s/^Priority:  .*/Priority: 900/" /usr/share/pam-configs/mkhomedir`
`sed -i "s/^Session-Interactive-Only:  .*/#/" /usr/share/pam-configs/mkhomedir`

echo "Please select Create home directory on login"

read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

sudo pam-auth-update
