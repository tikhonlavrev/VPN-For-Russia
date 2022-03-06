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
tls="$(cat ~/log-install.txt | grep -w "Vmess TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Vmess None TLS" | cut -d: -f2|sed 's/ //g')"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m       ⇱ Change Port Xray ⇲       \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e "   [1]  Change TLS $tls"
echo -e "   [2]  Change None TLS $none"
echo -e "   [x]  Exit"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p "Select From Options [1-2 or x] :  " prot
echo -e ""
case $prot in
1)
read -p "New Port TLS: " tls1
if [ -z $tls1 ]; then
echo "Please Input Port"
exit 0
fi

cek=$(netstat -nutlp | grep -w $tls1)
if [[ -z $cek ]]; then
sed -i "s/: $tls/: $tls1/g" /etc/xray/config.json
sed -i "s/   - XRAY  Vmess TLS         : $tls/   - XRAY  Vmess TLS         : $tls1/g" /root/log-install.txt
sed -i "s/   - XRAY  Vless TLS         : $tls/   - XRAY  Vless TLS         : $tls1/g" /root/log-install.txt
iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport $tls -j ACCEPT
iptables -D INPUT -m state --state NEW -m udp -p udp --dport $tls -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $tls1 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport $tls1 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save > /dev/null
netfilter-persistent reload > /dev/null
systemctl restart xray > /dev/null
echo -e "\e[032;1mPort $tls1 modified successfully\e[0m"
else
echo "Port $tls1 is used"
fi
;;
2)
echo "Input Only 2 Character (eg : 69)"
read -p "New Port None TLS: " none1
if [ -z $none1 ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $none1)
if [[ -z $cek ]]; then
sed -i "s/: $none/: $none1/g" /etc/xray/config.json
sed -i "s/   - XRAY  Vmess None TLS    : $none/   - XRAY  Vmess None TLS    : $none1/g" /root/log-install.txt
sed -i "s/   - XRAY  Vless None TLS    : $none/   - XRAY  Vless None TLS    : $none1/g" /root/log-install.txt
iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport $none -j ACCEPT
iptables -D INPUT -m state --state NEW -m udp -p udp --dport $none -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $none1 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport $none1 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save > /dev/null
netfilter-persistent reload > /dev/null
systemctl restart xray > /dev/null
echo -e "\e[032;1mPort $none1 modified successfully\e[0m"
else
echo "Port $none1 is used"
fi
;;
x)
exit
menu
;;
*)
echo "Please enter an correct number"
;;
esac
echo ""
read -n 1 -s -r -p "Press any key to back on menu"

menu