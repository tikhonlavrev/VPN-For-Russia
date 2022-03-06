#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################


red='\e[1;31m'
green='\e[1;32m'
yl='\033[1;33m'
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

cekray=`cat /root/log-install.txt | grep -ow "XRAY" | sort | uniq`
if [ "$cekray" = "XRAY" ]; then
rekk='xray'
else
rekk='v2ray'
fi
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m      • Restart ALL Service •      \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

systemctl restart ohp-ssh
echo -e "[ ${green}ok${NC} ] Restarting ohp "
sleep 1
systemctl restart ohp-db
systemctl restart ohp-opn
systemctl restart stunnel4
echo -e "[ ${green}ok${NC} ] Restarting stunnel4 "
sleep 1
systemctl restart wg-quick@wg0
echo -e "[ ${green}ok${NC} ] Restarting wireguard "
sleep 1
systemctl restart l2tpd
echo -e "[ ${green}ok${NC} ] Restarting l2tp "
sleep 1
systemctl restart accel-ppp
echo -e "[ ${green}ok${NC} ] Restarting sstp "
systemctl restart pptpd
echo -e "[ ${green}ok${NC} ] Restarting pptp "
sleep 1
systemctl restart trojan-go
echo -e "[ ${green}ok${NC} ] Restarting trojan go "
sleep 1
systemctl restart shadowsocks-libev
echo -e "[ ${green}ok${NC} ] Restarting shadowsokcs "
sleep 1
systemctl restart $rekk
echo -e "[ ${green}ok${NC} ] Restarting $rekk "
sleep 1
systemctl restart ssrmu
echo -e "[ ${green}ok${NC} ] Restarting shadowsocks-r "
sleep 1
systemctl restart dropbear
echo -e "[ ${green}ok${NC} ] Restarting dropbear "
sleep 1
systemctl restart xtls
echo -e "[ ${green}ok${NC} ] Restarting xtls "
sleep 1
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
