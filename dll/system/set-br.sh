#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################


clear
cd
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
NC='\e[0m'
curl -sS https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/resources/ascii-home
echo "Setting UP"
echo "Progress..."
sleep 3
echo ""
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
PERMISSION
if [ "$res" = "Permission Accepted..." ]; then
green "Permission Accepted.."
else
red "Permission Denied!"
exit 0
fi
sleep 3
echo -e "
"
date
echo ""
sleep 1
echo -e "[ ${green}INFO${NC} ] Checking... "
sleep 2
sleep 1
echo -e "[ ${green}INFO${NC} ] Download & Install rclone... "
curl -fsSL https://rclone.org/install.sh | bash > /dev/null 2>&1
printf "q\n" | rclone config > /dev/null 2>&1
sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading rclone config ... "
wget -q -O /root/.config/rclone/rclone.conf "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/dll/system/rclone.conf"
git clone https://github.com/magnific0/wondershaper.git &> /dev/null
cd wondershaper
sleep 1
echo -e "[ ${green}INFO${NC} ] Installing wondershaper... "
make install > /dev/null 2>&1
cd
rm -rf wondershaper > /dev/null 2>&1
echo > /home/limit

pkgs='msmtp-mta ca-certificates bsd-mailx'
if ! dpkg -s $pkgs > /dev/null 2>&1; then
sleep 1
echo -e "[ ${green}INFO${NC} ] Installing... "
apt install -y $pkgs > /dev/null 2>&1
else
sleep 1
echo -e "[ ${green}INFO${NC} ] Already Installed... "
fi
sleep 1
echo -e "[ ${green}INFO${NC} ] Creating service... "

cat> /etc/msmtprc << EOF
account default
host smtp.gmail.com
port 587
from 3bulanmm@gmail.com
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
auth on
user 3bulanmm
password aww123321aww
logfile ~/.msmtp.log
EOF

chown -R www-data:www-data /etc/msmtprc
sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading files... "
wget -q -O /usr/bin/backup "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/dll/system/backup.sh" && chmod +x /usr/bin/backup
wget -q -O /usr/bin/bckp "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/dll/system/bckp.sh" && chmod +x /usr/bin/bckp
wget -q -O /usr/bin/restore "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/dll/system/restore.sh" && chmod +x /usr/bin/restore
wget -q -O /usr/bin/kernel-updt "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/dll/system/kernel-updt.sh" && chmod +x /usr/bin/kernel-updt
wget -q -O /usr/bin/ubuntu-kernel "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/dll/system/ubuntu-kernel.sh" && chmod +x /usr/bin/ubuntu-kernel
wget -q -O /usr/bin/ram "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/dll/system/ram.py" && chmod +x /usr/bin/ram
wget -q -O /usr/bin/speedtest "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/dll/system/speedtest_cli.py" && chmod +x /usr/bin/speedtest
wget -q -O /usr/bin/swapkvm "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/dll/system/swapkvm.sh" && chmod +x /usr/bin/swapkvm
wget -q -O /usr/bin/wbmn "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/dll/system/webmin.sh" && chmod +x /usr/bin/wbmn
wget -q -O /usr/bin/update-script "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/dll/system/update-script.sh" && chmod +x /usr/bin/update-script
wget -q -O /usr/bin/cloudflare-pointing "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/dll/cloudflare-pointing.sh" && chmod +x /usr/bin/cloudflare-pointing
wget -q -O /usr/bin/cloudflare-setting "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/dll/cloudflare-setting.sh" && chmod +x /usr/bin/cloudflare-setting
wget -q -O /usr/bin/cleaner "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/dll/logcleaner.sh" && chmod +x /usr/bin/cleaner

if [ ! -f "/etc/cron.d/cleaner" ]; then
cat> /etc/cron.d/cleaner << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
* */6 * * * root /usr/bin/cleaner
END
fi

service cron restart > /dev/null 2>&1

rm -f /root/set-br.sh