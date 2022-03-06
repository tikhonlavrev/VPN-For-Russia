#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################


red='\e[1;31m'
green='\e[1;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }


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
echo -e "${red}==[ READ FIRST ]==${NC}

1. Format must be html if you don't understand please google it
2. Edit the text as you wish
3. If it has been edited to save press CTRL + x + y + enter
4. To cancel / exit press CTRL + x + n

nb : don't forget to restart the vps after editing the banner
"
echo -n "Wanna go ? (y/n)? "
read answer
if [ -z $answer ]; then
setting-menu
fi
if [ "$answer" == "${answer#[Yy]}" ] ;then
setting-menu
else
clear
nano /etc/issue.net
setting-menu
fi