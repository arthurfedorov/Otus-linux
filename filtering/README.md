# Фильтрация трафика

## Домашнее задание

Сценарии iptables

1. Реализовать knocking port - centralRouter может попасть на ssh inetrRouter через knock скрипт. Пример в материалах

2. Добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост

3. Запустить nginx на centralServer

4. Пробросить 80й порт на inetRouter2 8080

5. Дефолт в инет оставить через inetRouter

* реализовать проход на 80й порт без маскарадинга

## Выполнение

Что делаю:


1. centralServer
   echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
   echo "GATEWAY=192.168.0.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1

2. centralRouter
   echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
   echo "GATEWAY=192.168.255.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
   echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
   sysctl net.ipv4.conf.all.forwarding=1


inetRouter
sysctl net.ipv4.conf.all.forwarding=1
ip route add 192.168.0.0/24 via 192.168.255.2
iptables -t nat -A POSTROUTING ! -d 192.168.0.0/16 -o eth0 -j MASQUERADE
изменить параметр PasswordAuthentication в /etc/ssh/sshd_config


## Полезные ссылки

1. [Учебник по iptables](https://binarylife.ru/iptables-u32-uchebnik/)

2. [Руководство по iptables (Iptables Tutorial 1.1.19)](https://www.opennet.ru/docs/RUS/iptables/) - толкое руководство
