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
TrojanTrial=trial`</dev/urandom tr -dc A-Z0-9 | head -c4`
Hariii=1
Passss=1
source /var/lib/scrz-prem/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
fi
tr="$(cat ~/log-install.txt | grep -w "Trojan " | cut -d: -f2|sed 's/ //g')" && echo $tr
until [[ $TrojanTrial =~ ^[a-zA-Z0-9_]+$ && ${TrojanTrial_EXISTS} == '0' ]]; do
		
		TrojanTrial_EXISTS=$(grep -w $TrojanTrial /etc/xray/config.json | wc -l)

		if [[ ${TrojanTrial_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			exit 1
		fi
	done

uuid=$(cat /proc/sys/kernel/random/uuid)
exp=`date -d "$Hariii days" +"%Y-%m-%d"`
sed -i '/#trojanTLS$/a\#! '"$TrojanTrial $exp"'\
},{"password": "'""$uuid""'","email": "'""$TrojanTrial""'"' /etc/xray/config.json

systemctl restart xray
trojanlink="trojan://${uuid}@${domain}:${tr}"
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m         ⇱ TROJAN ACCOUNT ⇲        \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Remarks : ${TrojanTrial}"
echo -e "Host/IP : ${domain}"
echo -e "port : ${tr}"
echo -e "Key : ${uuid}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link : ${trojanlink}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Expired On : $exp"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"

trojan-menu
