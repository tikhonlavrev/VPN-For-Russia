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
L2TPTrial=trial`</dev/urandom tr -dc A-Z0-9 | head -c4`
Hariii=1
Passss=1
source /var/lib/scrz-prem/ipvps.conf
if [[ "$IP" = "" ]]; then
PUBLIC_IP=$(curl -sS ifconfig.me);
else
PUBLIC_IP=$IP
fi

until [[ $L2TPTrial =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do

		CLIENT_EXISTS=$(grep -w $L2TPTrial /var/lib/scrz-prem/data-user-l2tp | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			exit 1
		fi
	done

exp=`date -d "$Hariii days" +"%Y-%m-%d"`
clear

# Add or update VPN user
cat >> /etc/ppp/chap-secrets <<EOF
"$L2TPTrial" l2tpd "$Passss" *
EOF

Passss_ENC=$(openssl passwd -1 "$Passss")
cat >> /etc/ipsec.d/passwd <<EOF
$L2TPTrial:$Passss_ENC:xauth-psk
EOF

# Update file attributes
chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*
echo -e "### $L2TPTrial $exp">>"/var/lib/scrz-prem/data-user-l2tp"
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"		
echo -e "\E[44;1;39m       ⇱ Trial L2TP Account ⇲      \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"		
echo -e ""
echo -e "Server IP : $PUBLIC_IP"
echo -e "IPsec PSK : myvpn"
echo -e "Username : $L2TPTrial"
echo -e "Password : $Passss"
echo -e "Expired ON : $exp"
echo -e ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"		
echo ""
read -n 1 -s -r -p "Press any key to back on menu"

ipsec-menu