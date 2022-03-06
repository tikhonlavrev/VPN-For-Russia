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

cek=$(service ssh status | grep active | cut -d ' ' -f5)
if [ "$cek" = "active" ]; then
stat=-f5
else
stat=-f7
fi
cekray=`cat /root/log-install.txt | grep -ow "XRAY" | sort | uniq`
if [ "$cekray" = "XRAY" ]; then
rekk='xray'
becek='XRAY'
else
rekk='v2ray'
becek='V2RAY'
fi

ssh=$(service ssh status | grep active | cut -d ' ' $stat)
if [ "$ssh" = "active" ]; then
ressh="${green}AKTIF${NC}"
else
ressh="${red}MATI${NC}"
fi
sshstunel=$(service stunnel4 status | grep active | cut -d ' ' $stat)
if [ "$sshstunel" = "active" ]; then
resst="${green}AKTIF${NC}"
else
resst="${red}MATI${NC}"
fi
wg=$(service wg-quick@wg0 status | grep active | cut -d ' ' $stat)
if [ "$wg" = "active" ]; then
reswg="${green}AKTIF${NC}"
else
reswg="${red}MATI${NC}"
fi
l22tp=$(service xl2tpd status | grep active | cut -d ' ' $stat)
if [ "$l22tp" = "active" ]; then
resl2tp="${green}AKTIF${NC}"
else
resl2tp="${red}MATI${NC}"
fi
pptp=$(service pptpd status | grep active | cut -d ' ' $stat)
if [ "$pptp" = "active" ]; then
respptp="${green}AKTIF${NC}"
else
respptp="${red}MATI${NC}"
fi
sstp=$(service accel-ppp status | grep active | cut -d ' ' $stat)
if [ "$sstp" = "active" ]; then
resstp="${green}AKTIF${NC}"
else
resstp="${red}MATI${NC}"
fi
ssr=$(service ssrmu status | grep active | cut -d ' ' $stat)
if [ "$ssr" = "active" ]; then
ressr="${green}AKTIF${NC}"
else
ressr="${red}MATI${NC}"
fi
sodosok=$(service shadowsocks-libev status | grep active | cut -d ' ' $stat)
if [ "$sodosok" = "active" ]; then
resss="${green}AKTIF${NC}"
else
resss="${red}MATI${NC}"
fi
v2r=$(service $rekk status | grep active | cut -d ' ' $stat)
if [ "$v2r" = "active" ]; then
resv2r="${green}AKTIF${NC}"
else
resv2r="${red}MATI${NC}"
fi
vles=$(service $rekk status | grep active | cut -d ' ' $stat)
if [ "$vles" = "active" ]; then
resvles="${green}AKTIF${NC}"
else
resvles="${red}MATI${NC}"
fi
trj=$(service $rekk status | grep active | cut -d ' ' $stat)
if [ "$trj" = "active" ]; then
restr="${green}AKTIF${NC}"
else
restr="${red}MATI${NC}"
fi
trjgo=$(service trojan-go status | grep active | cut -d ' ' $stat)
if [ "$trjgo" = "active" ]; then
restrgo="${green}AKTIF${NC}"
else
restrgo="${red}MATI${NC}"
fi
# systemctl enable ssh && systemctl restart ssh 
# systemctl enable stunnel4 && systemctl restart stunnel4
# systemctl enable wg-quick@wg0 && systemctl restart wg-quick@wg0
# systemctl enable xl2tpd && systemctl restart xl2tpd
# systemctl enable accel-ppp && systemctl restart accel-ppp
# systemctl enable pptpd && systemctl restart pptpd
# systemctl enable trojan-go && systemctl restart trojan-go
# systemctl enable shadowsocks-libev && systemctl restart shadowsocks-libev
# systemctl enable v2ray && systemctl restart v2ray
# systemctl enable ssrmu && systemctl restart ssrmu

clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m      ⇱ Service ALL Status ⇲       \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "
[ SSH & VPN ]             : $ressh
[ STUNNEL ]               : $resst
[ WIREGUARD ]             : $reswg
[ L2TP ]                  : $resl2tp
[ PPTP ]                  : $respptp
[ SSTP ]                  : $resstp
[ SSR ]                   : $ressr
[ ShadowSocks]            : $resss"
if [ "$rekk" != "xray" ]; then
echo -e "[ V2RAY ]                 : $resv2r"
else
echo -e "[ XRAY ]                  : $resv2r"
fi
echo -e "[ VLESS ]                 : $resvles
[ TROJAN ]                : $restr
[ TROJAN-GO ]             : $restrgo
"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu