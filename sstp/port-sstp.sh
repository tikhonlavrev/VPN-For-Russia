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
sstp="$(cat ~/log-install.txt | grep -i SSTP | cut -d: -f2|sed 's/ //g')"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m       ⇱ Change Port SSTP ⇲        \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "      Change Port $sstp"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -p "New Port sstp: " sstp2
if [ -z $sstp2 ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $sstp2)
if [[ -z $cek ]]; then
sed -i "s/$sstp/$sstp2/g" /etc/accel-ppp.conf
sed -i "s/   - SSTP VPN                : $sstp/   - SSTP VPN                : $sstp2/g" /root/log-install.txt
iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport $sstp -j ACCEPT
iptables -D INPUT -m state --state NEW -m udp -p udp --dport $sstp -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $sstp2 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport $sstp2 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save > /dev/null
netfilter-persistent reload > /dev/null
systemctl restart accel-ppp> /dev/null
echo -e "\e[032;1mPort $sstp2 modified successfully\e[0m"
else
echo "Port $sstp2 is used"
fi
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu