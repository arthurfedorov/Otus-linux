# Статическая и динамическая маршрутизация

## Домашнее задание

OSPF
- Поднять три виртуалки
- Объединить их разными private network
1. Поднять OSPF между машинами средствами программных маршрутизаторов на выбор: Quagga, FRR или BIRD
2. Изобразить ассиметричный роутинг
3. Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным

Формат сдачи:
Vagrantfile + ansible

## Выполнение

В качестве программного роутера было выбрано решение Quagga. Посмотрел на FRR, в принципе тоже неплох, но вероятно были какие-то проблемы с серверами и загрузка rpm-ника шла по 10-15 минут на каждой машине, что не есть быстро. Вернулся на Quagga.


```bash
[root@router1 ~]ip r
default via 10.0.2.2 dev eth0 proto dhcp metric 100 
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 metric 100 
192.168.230.0/29 dev eth1 proto kernel scope link src 192.168.230.1 metric 101 
192.168.240.0/29 dev eth2 proto kernel scope link src 192.168.240.1 metric 102 
192.168.250.0/29 proto zebra metric 20 
        nexthop via 192.168.230.2 dev eth1 weight 1 
        nexthop via 192.168.240.2 dev eth2 weight 1 
```

```bash
[root@router2 ~] ip r
default via 10.0.2.2 dev eth0 proto dhcp metric 100 
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 metric 100 
192.168.230.0/29 proto zebra metric 20 
        nexthop via 192.168.240.1 dev eth1 weight 1 
        nexthop via 192.168.250.2 dev eth2 weight 1 
192.168.240.0/29 dev eth1 proto kernel scope link src 192.168.240.2 metric 101 
192.168.250.0/29 dev eth2 proto kernel scope link src 192.168.250.1 metric 102 
```

```bash
[root@router3 ~] ip r
default via 10.0.2.2 dev eth0 proto dhcp metric 100 
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 metric 100 
192.168.230.0/29 dev eth1 proto kernel scope link src 192.168.230.2 metric 101 
192.168.240.0/29 proto zebra metric 20 
        nexthop via 192.168.230.1 dev eth1 weight 1 
        nexthop via 192.168.250.1 dev eth2 weight 1 
192.168.250.0/29 dev eth2 proto kernel scope link src 192.168.250.2 metric 102 
```

![scheme.png](ospf-homework.png)
