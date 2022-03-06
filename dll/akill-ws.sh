#!/bin/bash
#AutoKill V2ray/Vmess
# Credit: nandoscrz
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################



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

cekray=`cat /root/log-install.txt | grep -ow "XRAY" | sort | uniq`
if [ "$cekray" = "XRAY" ]; then
rekk='xray'
else
rekk='v2ray'
fi

mkdir -p /etc/multi
#echo -n /var/log/$rekk/access.log
echo -n > /tmp/oth.txt
data=( `cat /etc/$rekk/config.json | grep '^###' | cut -d ' ' -f 2`);

for akun in "${data[@]}"
do
echo -n >> /tmp/$akun
if [[ -z "$akun" ]]; then
akun="tidakada"
fi

echo -n > /tmp/ipvmss.txt
data2=( `netstat -anp | grep ESTABLISHED | grep tcp6 | grep $rekk | awk '{print $5}' | cut -d: -f1 | sort | uniq`);
for ip in "${data2[@]}"
do
jum=$(cat /var/log/$rekk/access.log | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
for lx in "${jum[@]}" 
do
echo "#!/bin/bash" >> /tmp/$akun
echo "iptables -A INPUT -s $lx -j DROP" >> /tmp/$akun
done
fi

jum2=$(cat /tmp/ipvmss.txt)
sed -i "/$jum2/d" /tmp/oth.txt > /dev/null 2>&1
done
echo "sleep 60" >> /tmp/$akun

data23=( `netstat -anp | grep ESTABLISHED | grep tcp6 | grep $rekk | awk '{print $5}' | cut -d: -f1 | sort | uniq`);
for ip2 in "${data23[@]}"
do
jum2=$(cat /var/log/$rekk/access.log | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip2 | sort | uniq)
if [[ "$jum2" = "$ip2" ]]; then
echo "iptables -D INPUT -s $jum2 -j DROP" >> /tmp/$akun

fi
done

if [[ $(wc -l </tmp/$akun) -ge 6 ]] 
then
chmod +x /tmp/$akun
mv /tmp/$akun /etc/multi >/dev/null 2>&1

cat> /etc/cron.d/$akun <<END
SHELL=/bin/sh
PATH=/etc/multi:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# m h dom mon dow user  command
*/1 * * * * root /etc/multi/$akun
END

service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1

else
rm -f /etc/multi/$akun >/dev/null 2>&1
rm -f /etc/cron.d/$akun >/dev/null 2>&1
fi

rm -f /tmp/ipvmss.txt
rm -f /tmp/oth.txt
rm -f /tmp/$akun
done


exp=$(date)
echo -e "Berhasil cek pada : ${exp}"