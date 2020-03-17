Commands:

yum update -y
timedatectl set-timezone Europe/Moscow
hostnamectl set-hostname ipa.hakase-labs.io
vi /etc/hosts
yum install ipa-server bind-dyndb-ldap ipa-server-dns -y
ipa-server-install -U --realm HAKASE-LABS.IO --domain hakase-labs.io -p 12345678 -a 12345678 --hostname=ipa.hakase-labs.io --ip-address=192.168.100.10 --setup-dns --auto-forwarders --no-reverse
echo "12345678" kinit admin | kinit admin
ipa user add pushkin --first=Alexander --last=Pushkin --email=a.pushkin@poet.ru --shell=/bin/bash
