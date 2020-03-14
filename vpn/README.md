# VPN и туннели

## Домашнее задание

1. Между двумя виртуалками поднять vpn в режимах:

- tun
- tap
Прочуствовать разницу.

2. Поднять RAS на базе OpenVPN с клиентскими сертификатами, подключиться с локальной машины на виртуалку

3. * Самостоятельно изучить, поднять ocserv и подключиться с хоста к виртуалке

## Выполнение

### tun/tap

1. Поднимем vagrant:

```bash
vagrant up
```

2. Далее необходимо запустить playbook - **tun-provision.yml**. 

```bash
ansible-playbook tun-provision.yml -v
```

3. На машине **server** запускаем *iperf3 -s &* на **client** *iperf3 -c 10.10.10.1 -t 40 -i 5*. Получаем следующий результат:

```bash
Accepted connection from 10.10.10.2, port 46018
[  5] local 10.10.10.1 port 5201 connected to 10.10.10.2 port 46020
[ ID] Interval           Transfer     Bandwidth
[  5]   0.00-1.00   sec  24.5 MBytes   205 Mbits/sec
[  5]   1.00-2.00   sec  25.5 MBytes   214 Mbits/sec
[  5]   2.00-3.00   sec  26.0 MBytes   218 Mbits/sec
[  5]   3.00-4.01   sec  24.9 MBytes   207 Mbits/sec
[  5]   4.01-5.00   sec  25.2 MBytes   213 Mbits/sec
[  5]   5.00-6.00   sec  24.3 MBytes   204 Mbits/sec
[  5]   6.00-7.01   sec  24.7 MBytes   205 Mbits/sec
[  5]   7.01-8.01   sec  24.7 MBytes   208 Mbits/sec
[  5]   8.01-9.01   sec  25.0 MBytes   210 Mbits/sec
[  5]   9.01-10.00  sec  25.3 MBytes   213 Mbits/sec
[  5]  10.00-11.01  sec  24.1 MBytes   201 Mbits/sec
[  5]  11.01-12.00  sec  25.2 MBytes   213 Mbits/sec
[  5]  12.00-13.01  sec  25.5 MBytes   213 Mbits/sec
[  5]  13.01-14.00  sec  24.3 MBytes   204 Mbits/sec
[  5]  14.00-15.00  sec  25.4 MBytes   213 Mbits/sec
[  5]  15.00-16.00  sec  24.9 MBytes   210 Mbits/sec
[  5]  16.00-17.01  sec  23.0 MBytes   193 Mbits/sec
[  5]  17.01-18.00  sec  25.1 MBytes   212 Mbits/sec
[  5]  18.00-19.00  sec  24.4 MBytes   205 Mbits/sec
[  5]  19.00-20.01  sec  25.9 MBytes   216 Mbits/sec
[  5]  20.01-21.01  sec  24.7 MBytes   207 Mbits/sec
[  5]  21.01-22.00  sec  24.8 MBytes   209 Mbits/sec
[  5]  22.00-23.01  sec  25.1 MBytes   209 Mbits/sec
[  5]  23.01-24.01  sec  25.1 MBytes   210 Mbits/sec
[  5]  24.01-25.00  sec  25.5 MBytes   215 Mbits/sec
[  5]  25.00-26.00  sec  26.0 MBytes   218 Mbits/sec
[  5]  26.00-27.00  sec  25.5 MBytes   214 Mbits/sec
[  5]  27.00-28.01  sec  25.6 MBytes   214 Mbits/sec
[  5]  28.01-29.00  sec  23.2 MBytes   195 Mbits/sec
[  5]  29.00-30.00  sec  23.9 MBytes   200 Mbits/sec
[  5]  30.00-31.00  sec  20.8 MBytes   175 Mbits/sec
[  5]  31.00-32.00  sec  23.1 MBytes   194 Mbits/sec
[  5]  32.00-33.01  sec  24.7 MBytes   206 Mbits/sec
[  5]  33.01-34.01  sec  25.0 MBytes   210 Mbits/sec
[  5]  34.01-35.00  sec  25.4 MBytes   214 Mbits/sec
[  5]  35.00-36.00  sec  21.4 MBytes   179 Mbits/sec
[  5]  36.00-37.00  sec  22.2 MBytes   187 Mbits/sec
[  5]  37.00-38.00  sec  24.0 MBytes   202 Mbits/sec
[  5]  38.00-39.01  sec  23.7 MBytes   197 Mbits/sec
[  5]  39.01-40.00  sec  24.8 MBytes   209 Mbits/sec
[  5]  40.00-40.04  sec   817 KBytes   193 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth
[  5]   0.00-40.04  sec  0.00 Bytes  0.00 bits/secsender
[  5]   0.00-40.04  sec   983 MBytes   206 Mbits/secreceiver
```

4. Дропаем созданные машины, для следующего теста:

```
vagrant destroy --force
```

5. Снова разворачиваем *vagrant up*, после разворота, запусаем playbook **tap-provision.yml**:

```bash
ansible-playbook tap-provision.yml -v
```

6. Снова на машине **server** запускаем *iperf3 -s &* на **client** *iperf3 -c 10.10.10.1 -t 40 -i 5*. Получаем следующий результат:

```bash
Accepted connection from 10.10.10.2, port 33632
[  5] local 10.10.10.1 port 5201 connected to 10.10.10.2 port 33634
[ ID] Interval           Transfer     Bandwidth
[  5]   0.00-1.00   sec  12.4 MBytes   104 Mbits/sec
[  5]   1.00-2.01   sec  13.2 MBytes   110 Mbits/sec
[  5]   2.01-3.01   sec  13.4 MBytes   112 Mbits/sec
[  5]   3.01-4.00   sec  13.4 MBytes   113 Mbits/sec
[  5]   4.00-5.00   sec  5.81 MBytes  48.8 Mbits/sec
[  5]   5.00-6.00   sec  10.4 MBytes  87.1 Mbits/sec
[  5]   6.00-7.00   sec  6.02 MBytes  50.6 Mbits/sec
[  5]   7.00-8.00   sec  9.97 MBytes  83.6 Mbits/sec
[  5]   8.00-9.00   sec  6.10 MBytes  51.3 Mbits/sec
[  5]   9.00-10.00  sec  10.2 MBytes  85.4 Mbits/sec
[  5]  10.00-11.00  sec  5.81 MBytes  48.9 Mbits/sec
[  5]  11.00-12.00  sec  8.44 MBytes  70.8 Mbits/sec
[  5]  12.00-13.00  sec  6.20 MBytes  51.8 Mbits/sec
[  5]  13.00-14.00  sec  11.7 MBytes  98.1 Mbits/sec
[  5]  14.00-15.00  sec  6.41 MBytes  53.7 Mbits/sec
[  5]  15.00-16.01  sec  12.8 MBytes   108 Mbits/sec
[  5]  16.01-17.00  sec  6.51 MBytes  54.8 Mbits/sec
[  5]  17.00-18.00  sec  5.75 MBytes  48.2 Mbits/sec
[  5]  18.00-19.00  sec  7.68 MBytes  64.6 Mbits/sec
[  5]  19.00-20.01  sec  4.87 MBytes  40.6 Mbits/sec
[  5]  20.01-21.00  sec  7.36 MBytes  62.0 Mbits/sec
[  5]  21.00-22.00  sec  8.01 MBytes  67.1 Mbits/sec
[  5]  22.00-23.00  sec  7.09 MBytes  59.6 Mbits/sec
[  5]  23.00-24.00  sec  6.95 MBytes  58.2 Mbits/sec
[  5]  24.00-25.00  sec  8.14 MBytes  68.3 Mbits/sec
[  5]  25.00-26.00  sec  8.13 MBytes  68.0 Mbits/sec
[  5]  26.00-27.01  sec  5.46 MBytes  45.5 Mbits/sec
[  5]  27.01-28.00  sec  7.73 MBytes  65.3 Mbits/sec
[  5]  28.00-29.00  sec  6.70 MBytes  56.2 Mbits/sec
[  5]  29.00-30.00  sec  5.68 MBytes  47.7 Mbits/sec
[  5]  30.00-31.00  sec  4.59 MBytes  38.5 Mbits/sec
[  5]  31.00-32.01  sec  8.95 MBytes  74.4 Mbits/sec
[  5]  32.01-33.01  sec  7.64 MBytes  64.2 Mbits/sec
[  5]  33.01-34.00  sec  8.40 MBytes  71.1 Mbits/sec
[  5]  34.00-35.01  sec  8.44 MBytes  70.0 Mbits/sec
[  5]  35.01-36.00  sec  11.9 MBytes   101 Mbits/sec
[  5]  36.00-37.00  sec  5.97 MBytes  50.1 Mbits/sec
[  5]  37.00-38.00  sec  7.42 MBytes  62.2 Mbits/sec
[  5]  38.00-39.00  sec  8.44 MBytes  70.9 Mbits/sec
[  5]  39.00-40.00  sec  6.72 MBytes  56.4 Mbits/sec
[  5]  40.00-40.10  sec   937 KBytes  79.4 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth
[  5]   0.00-40.10  sec  0.00 Bytes  0.00 bits/secsender
[  5]   0.00-40.10  sec   328 MBytes  68.6 Mbits/secreceiver
```

Делаем вывод, что tun шустрее tap, за счет оверхеда, который накладывает ethernet.

### RAS на базе OpenVPN

1. Дропнем машины и поднимем заново

```bash
vagrant destroy --force
```

```bash
vagrant up
```

2. После разворота, необходимо запустить playbook **ras.yml**

```bash
ansible-playbook ras.yml -v
```

3. В корневой папке находится папка**files**. Необходимо собрать в одном месте файлы из этой папки (не смог понять, как сделать этом fetch'ем). Требуемые файлы - ca.crt, client.crt, client.key, client.conf.

4. Далее необходимо запустить openvpn командой:

```bash
sudo openvpn --config client.conf
```

5. Проверяем наличие маршрута командой **ip r**. Все работает.

### Самостоятельно изучить, поднять ocserv и подключиться с хоста к виртуалке

Не осилил, возможно когда-нибудь в другой раз.