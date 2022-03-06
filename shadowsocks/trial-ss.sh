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
SSTrial=trial`</dev/urandom tr -dc A-Z0-9 | head -c4`
Hariii=1
Passss=1
IP=$(curl -sS ifconfig.me);
lastport1=$(grep "port_tls" /etc/shadowsocks-libev/akun.conf | tail -n1 | awk '{print $2}')
lastport2=$(grep "port_http" /etc/shadowsocks-libev/akun.conf | tail -n1 | awk '{print $2}')
if [[ $lastport1 == '' ]]; then
tls=2443
else
tls="$((lastport1+1))"
fi
if [[ $lastport2 == '' ]]; then
http=3443
else
http="$((lastport2+1))"
fi
until [[ $SSTrial =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		
		CLIENT_EXISTS=$(grep -w $SSTrial /etc/shadowsocks-libev/akun.conf | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m           ⇱ Trial SS ⇲            \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

			echo ""
			echo "A client with the specified name was already created, please choose another name."
			echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"            
ss-menu
		fi
	done
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m           ⇱ Trial SS ⇲            \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

exp=`date -d "$Hariii days" +"%Y-%m-%d"`
cat > /etc/shadowsocks-libev/$SSTrial-tls.json<<END
{   
    "server":"0.0.0.0",
    "server_port":$tls,
    "password":"$SSTrial",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "no_delay":true,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=tls"
}
END
cat > /etc/shadowsocks-libev/$SSTrial-http.json <<-END
{
    "server":"0.0.0.0",
    "server_port":$http,
    "password":"$SSTrial",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "no_delay":true,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=http"
}
END
chmod +x /etc/shadowsocks-libev/$SSTrial-tls.json
chmod +x /etc/shadowsocks-libev/$SSTrial-http.json

systemctl start shadowsocks-libev-server@$SSTrial-tls.service > /dev/null 2>&1
systemctl enable shadowsocks-libev-server@$SSTrial-tls.service > /dev/null 2>&1
systemctl start shadowsocks-libev-server@$SSTrial-http.service > /dev/null 2>&1
systemctl enable shadowsocks-libev-server@$SSTrial-http.service > /dev/null 2>&1
tmp1=$(echo -n "aes-256-cfb:${SSTrial}@${IP}:$tls" | base64 -w0)
tmp2=$(echo -n "aes-256-cfb:${SSTrial}@${IP}:$http" | base64 -w0)
linkss1="ss://${tmp1}?plugin=obfs-local;obfs=tls;obfs-host=bing.com"
linkss2="ss://${tmp2}?plugin=obfs-local;obfs=http;obfs-host=bing.com"
echo -e "### $SSTrial $exp
port_tls $tls
port_http $http">>"/etc/shadowsocks-libev/akun.conf"
service cron restart > /dev/null 2>&1
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m           ⇱ Trial SS ⇲            \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -e "IP/Host : $IP"
echo -e "Port OBFS TLS : $tls"
echo -e "Port OBFS HTTP : $http"
echo -e "Password : $SSTrial"
echo -e "Method : aes-256-cfb"
echo -e "Expired On : $exp"
echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link OBFS TLS : $linkss1"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link OBFS HTTP : $linkss2"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"            
ss-menu