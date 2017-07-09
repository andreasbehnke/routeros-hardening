#!/bin/bash

# SSH

# - use very strong password
# - use public key for authentication
# - use strong crypto

PASSWORD=$(pwgen -s -y 21 1)
scp ~/.ssh/id_rsa.pub  admin@192.168.88.1:
sleep 1
ssh admin@192.168.88.1 'user ssh-keys import user=admin public-key-file=id_rsa.pub'
ssh admin@192.168.88.1 "user set 0 password=\"$PASSWORD\""
ssh admin@192.168.88.1 'ip ssh set strong-crypto=yes'
