#!/bin/bash

# https://www.manitonetworks.com/mikrotik/2016/5/24/mikrotik-router-hardening#neighbor-discovery

# SSH

# - use very strong password
# - use public key for authentication
# - use strong crypto
ROUTERIP="192.168.88.1"
PASSWORD=$(pwgen -s -y 20 1)
echo $PASSWORD
scp ~/.ssh/id_rsa.pub  admin@$ROUTERIP:
sleep 1
ssh admin@$ROUTERIP 'user ssh-keys import user=admin public-key-file=id_rsa.pub'
ssh admin@$ROUTERIP "user set 0 password=\"$PASSWORD\""
ssh admin@$ROUTERIP 'ip ssh set strong-crypto=yes'

# disable unused services

ssh admin@$ROUTERIP 'ip service disable [find name=telnet]'
ssh admin@$ROUTERIP 'ip service disable [find name=ftp]'
ssh admin@$ROUTERIP 'ip service disable [find name=www]'
ssh admin@$ROUTERIP 'ip service disable [find name=www-ssl]'
ssh admin@$ROUTERIP 'ip service disable [find name=api]'
ssh admin@$ROUTERIP 'ip service disable [find name=api-ssl]'
ssh admin@$ROUTERIP 'tool bandwidth-server set enabled=no'
ssh admin@$ROUTERIP 'ip dns set allow-remote-requests=no'
ssh admin@$ROUTERIP 'ip socks set enabled=no'

# disable MAC services for finding devices

ssh admin@$ROUTERIP 'tool mac-server set [find] disabled=yes'
ssh admin@$ROUTERIP 'tool mac-server mac-winbox set [find] disabled=yes'
ssh admin@$ROUTERIP 'tool mac-server ping set enabled=no'

# disable monitoring tool

ssh admin@$ROUTERIP 'tool romon set enabled=no'

# internet filter (https://kieranjones.uk/web-filtering-on-mikrotik-routerboard/)

ssh admin@$ROUTERIP 'ip dns set allow-remote-requests=yes'
ssh admin@$ROUTERIP 'ip dns set servers=199.85.126.20,199.85.127.20'
ssh admin@$ROUTERIP 'ip firewall filter add chain=input comment="TCP DNS" connection-state=new dst-port=53 protocol=tcp src-address=192.168.88.1/24'
ssh admin@$ROUTERIP 'ip firewall filter add chain=input comment="UDP DNS" connection-state=new dst-port=53 protocol=udp src-address=192.168.88.1/24'
