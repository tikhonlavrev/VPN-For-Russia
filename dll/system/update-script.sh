#!/bin/bash
wget -q -O /usr/bin/yow "https://raw.githubusercontent.com/tikhonlavrev/VPN-For-Russia/main/serv-updater.sh" && chmod +x /usr/bin/yow
screen -S updss yow