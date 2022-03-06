#!/bin/bash
# Check OS version
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################


clear
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
curl -sS https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/resources/ascii-home
echo "Wireguard"
echo "Progress..."
sleep 3
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }


Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[information]${Font_color_suffix}"

# if [[ -e /etc/wireguard/params ]]; then
    # echo -e "[ ${green}INFO$NC ] WireGuard already installed."
	# exit 1
# fi
sleep 1
echo -e "[ ${green}INFO$NC ] Setting up route"

# Detect public interface and pre-fill for the user
SERVER_PUB_NIC=$(ip -o $ANU -4 route show to default | awk '{print $5}');

sudo apt install iptables iptables-persistent -y >/dev/null 2>&1
# Make sure the directory exists (this does not seem the be the case on fedora)
mkdir -p /etc/wireguard >/dev/null 2>&1

chmod 600 -R /etc/wireguard/

sleep 1
echo -e "[ ${green}INFO$NC ] Generate key wireguard"
SERVER_PRIV_KEY=$(wg genkey)
SERVER_PUB_KEY=$(echo "$SERVER_PRIV_KEY" | wg pubkey)

# Save WireGuard settings
sleep 1
echo -e "[ ${green}INFO$NC ] Create config wireguard"
cat> /etc/wireguard/params << END
SERVER_PUB_NIC=$SERVER_PUB_NIC
SERVER_WG_NIC=wg0
SERVER_WG_IPV4=10.66.66.1
SERVER_PORT=7070
SERVER_PRIV_KEY=$SERVER_PRIV_KEY
SERVER_PUB_KEY=$SERVER_PUB_KEY
END

source /etc/wireguard/params

# Add server interface
sleep 1
echo -e "[ ${green}INFO$NC ] Adding server interface"
cat> /etc/wireguard/wg0.conf << END
[Interface]
Address = $SERVER_WG_IPV4/24
ListenPort = $SERVER_PORT
PrivateKey = $SERVER_PRIV_KEY
PostUp = sudo iptables -A FORWARD -i wg0 -j ACCEPT; sudo iptables -t nat -A POSTROUTING -o $SERVER_PUB_NIC -j MASQUERADE;
PostDown = sudo iptables -D FORWARD -i wg0 -j ACCEPT; sudo iptables -t nat -D POSTROUTING -o $SERVER_PUB_NIC -j MASQUERADE;
END

sleep 1
echo -e "[ ${green}INFO$NC ] Setting up iptables..."
sudo iptables -t nat -I POSTROUTING -s 10.66.66.1/24 -o $SERVER_PUB_NIC -j MASQUERADE
sudo iptables -I INPUT 1 -i wg0 -j ACCEPT
sudo iptables -I FORWARD 1 -i $SERVER_PUB_NIC -o wg0 -j ACCEPT
sudo iptables -I FORWARD 1 -i wg0 -o $SERVER_PUB_NIC -j ACCEPT
sudo iptables -I INPUT 1 -i $SERVER_PUB_NIC -p udp --dport 7070 -j ACCEPT
sudo iptables-save > /etc/iptables.up.rules
sudo iptables-restore -t < /etc/iptables.up.rules
sudo netfilter-persistent save >/dev/null 2>&1
sudo netfilter-persistent reload >/dev/null 2>&1

sleep 1
echo -e "[ ${green}INFO$NC ] Enable wireguard services..."
systemctl enable "wg-quick@wg0" >/dev/null 2>&1
systemctl start "wg-quick@wg0" >/dev/null 2>&1


# Check if WireGuard is running
systemctl is-active --quiet "wg-quick@wg0" >/dev/null 2>&1
WG_RUNNING=$?

# Tambahan

wget -q -O /usr/bin/add-wg "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/wireguard/add-wg.sh" && chmod +x /usr/bin/add-wg
wget -q -O /usr/bin/del-wg "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/wireguard/del-wg.sh" && chmod +x /usr/bin/del-wg
wget -q -O /usr/bin/cek-wg "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/wireguard/cek-wg.sh" && chmod +x /usr/bin/cek-wg
wget -q -O /usr/bin/renew-wg "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/wireguard/renew-wg.sh" && chmod +x /usr/bin/renew-wg
wget -q -O /usr/bin/trial-wg "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/wireguard/trial-wg.sh" && chmod +x /usr/bin/trial-wg
wget -q -O /usr/bin/port-wg "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/wireguard/port-wg.sh" && chmod +x /usr/bin/port-wg

wget -q -O /usr/bin/wg-menu "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/menu_all/wg-menu.sh" && chmod +x /usr/bin/wg-menu

sleep 1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "Wireguard install successfully..."
sleep 5
clear
rm -f /root/wg.sh >/dev/null 2>&1
