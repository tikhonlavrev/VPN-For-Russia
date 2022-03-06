#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################


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


x="ok"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m             ⇱ TRIAL MENU GENERATOR ⇲             \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;37mNB: Trial account will not logged into create log user\033[0m
\033[1;32mTrial-Generator\033[0m :

[\033[0;32m01\033[0m] • Generate Trial SSH & OpenVPN
[\033[0;32m02\033[0m] • Generate Trial Wireguard
[\033[0;32m03\033[0m] • Generate Trial L2TP
[\033[0;32m04\033[0m] • Generate Trial PPTP
[\033[0;32m05\033[0m] • Generate Trial SSTP
[\033[0;32m06\033[0m] • Generate Trial Shadowsocks-R
[\033[0;32m07\033[0m] • Generate Trial Shadowsocks
[\033[0;32m08\033[0m] • Generate Trial Vmess
[\033[0;32m09\033[0m] • Generate Trial VLESS
[\033[0;32m10\033[0m] • Generate Trial Trojan-GFW
[\033[0;32m11\033[0m] • Generate Trial Trojan-GO

[00] • Back to Main Menu \033[1;32m<\033[1;33m<\033[1;31m<\033[1;31m"
echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -ne "Select menu : "; read x

case "$x" in 
   1 | 01)
   clear
   trial
   ;;
   2 | 02)
   clear
   trial-wg
   ;;
   3 | 03)
   clear
   trial-l2tp
   ;;
   4 | 04)
   clear
   trial-pptp
   ;;
   5 | 05)
   clear
   trial-sstp
   ;;
   6 | 06)
   clear
   trial-ssr
   ;;
   7 | 07)
   clear
   trial-ss
   ;;
   8 | 08)
   clear
   trial-ws
   ;;
   9 | 09)
   clear
   trial-vless
   ;;
   10)
   clear
   trial-tr
   ;;
   11)
   clear
   trial-trgo
   ;;
   0 | 00)
   clear
   menu
   ;;
   *)
   info-menu
esac

#fim