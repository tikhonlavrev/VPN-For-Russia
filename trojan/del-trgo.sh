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

NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/trojan-go/akun.conf")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo -e "\E[44;1;39m    ⇱ Delete Trojan Go Account ⇲   \E[0m"
        echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
		echo ""
		echo "You have no existing clients!"
		echo ""
		echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
		read -n 1 -s -r -p "Press any key to back on menu"
        trojan-menu
	fi

	echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[44;1;39m    ⇱ Delete Trojan Go Account ⇲   \E[0m"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
	echo "     No  User      Expired "
	echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
	grep -E "^### " "/etc/trojan-go/akun.conf" | cut -d ' ' -f 2-3 | nl -s ') '
	echo -e "     0) Cancel"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
	    elif [[ ${CLIENT_NUMBER} == '0' ]]; then
            trojan-menu
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
CLIENT_NAME=$(grep -E "^### " "/etc/trojan-go/akun.conf" | cut -d ' ' -f 2-3 | sed -n "${CLIENT_NUMBER}"p)
user=$(grep -E "^### " "/etc/trojan-go/akun.conf" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/trojan-go/akun.conf" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
xid=$(grep -E "^### " "/etc/trojan-go/akun.conf" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
echo "$xid" > /etc/trojan-go/tmp
bcod=`cat /etc/trojan-go/tmp`
sed -i '/'$bcod'/d' /etc/trojan-go/config.json
sed -i "/^### $user $exp $xid/d" /etc/trojan-go/akun.conf

systemctl restart trojan-go
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo " Trojan Go Account Deleted Successfully"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo " Client Name : $user"
echo " Expired On  : $exp"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
rm /etc/trojan-go/tmp
read -n 1 -s -r -p "Press any key to back on menu"

trojan-menu