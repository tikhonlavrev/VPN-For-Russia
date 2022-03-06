#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################


red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
PERMISSION
if [ -f /home/needupdate ]; then
red "Your script need to update first !"
exit 0
elif [ "$res" = "Permission Accepted..." ]; then
echo -ne
else
red "Permission Denied!"
exit 0
fi

clear
source /etc/os-release
OS=$ID
ver=$VERSION_ID
sleep 2
if [[ $OS == 'ubuntu' ]]; then
ubuntu-kernel -i

elif [[ $OS == 'debian' ]]; then

if [[ "$ver" = "9" ]]; then
echo "Debian Ver 9 Blom support"

elif [[ "$ver" = "10" ]]; then
echo "Prosess.. update kernel"
echo -e "deb https://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list
apt update
apt install linux-image-5.10.0-0.bpo.5-amd64
echo "Update berhasil , auto reboot dalam 10 detik"
sleep 10
reboot
fi
fi
