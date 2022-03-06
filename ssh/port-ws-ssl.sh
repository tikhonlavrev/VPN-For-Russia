#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################


red='\e[1;31m'
green='\e[0;32m'
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
do1=`cat ~/log-install.txt | grep -w "SSH SSL Websocket" | cut -d: -f2 | awk '{print $1}'`
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m       ⇱ Change Port SSL Websocket ⇲      \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
echo ""
echo -e " Change Port $do1"
echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
echo -e ""
read -p "New Port SSL WS : " stl
echo -e ""

if [ -z $stl ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $stl)
if [[ -z $cek ]]; then
sed -i "s/$do1/$stl/g" /etc/stunnel/stunnel.conf
sed -i "s/SSH SSL Websocket       : $do1/SSH SSL Websocket       : $stl/g" /root/log-install.txt
systemctl stop scvpssshws.service >/dev/null 2>&1
tmux kill-session -t sshwsssl >/dev/null 2>&1
sleep 1
systemctl daemon-reload >/dev/null 2>&1
systemctl enable scvpssshws.service >/dev/null 2>&1
systemctl start scvpssshws.service >/dev/null 2>&1
systemctl restart stunnel4 >/dev/null 2>&1
echo -e "\e[032;1mPort $stl modified successfully\e[0m"
else
echo "Port $stl is used"
fi
read -n 1 -s -r -p "Press any key to back on menu"
setting-menu