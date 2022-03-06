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

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[ON]${Font_color_suffix}"
Error="${Red_font_prefix}[OFF]${Font_color_suffix}"
cek=/etc/cron.d/multi-ws
if [[ -f "$cek" ]]; then
sts="${Info}"
else
sts="${Error}"
fi

function start() {
multiws=/home/multi-ws
if [[ -f "$multiws" ]]; then
echo "Already ON Bro"
else
touch /home/multi-ws

cat> /etc/cron.d/multi-ws <<END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# m h dom mon dow user  command
*/1 * * * * root /usr/bin/akill-ws > /root/kill-log-vmess
END

service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1
sleep 1
echo -e "${green}Autokill-Vmess Started${NC}"
exit 0
fi
}

function stop() {
rm -f /home/multi-ws
rm -f /etc/cron.d/multi-ws
rm -f /root/kill-log-vmess
service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1
sleep 1
echo -e "${red}Autokill-Vmess Stopped${NC}"
exit 0
}

clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m            ⇱ AutoKill Vmess ⇲            \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
echo -e " Status $sts"
echo ""
echo -e "  1. Enable Mode Auto Kill VMess"
echo -e "  2. Disable Mode Auto Kill VMess"
echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -rp " Input Number : " -e num
if [[ "$num" = "1" ]]; then
start
elif [[ "$num" = "2" ]]; then
stop
else
clear
autokill-menu
fi
