# Файловые хранилища - NFS, SMB, FTP

## Домашнее задание

Vagrant стенд для NFS или SAMBA
NFS или SAMBA на выбор:

Vagrant up должен поднимать 2 виртуалки: сервер и клиент
на сервер должна быть расшарена директория
на клиента она должна автоматически монтироваться при старте (fstab или autofs)
в шаре должна быть папка upload с правами на запись - требования для NFS: NFSv3 по UDP, включенный firewall

Задание со * Настроить аутентификацию через KERBEROS

## Выполнение

Выбран NFS.

1. Поднимаем vagrant:

```bash
vagrant up
```

2. Запускаем playbook

```bash
ansible-playbook provision.yml -vv
```

3. Заходим на **client** и добавляем рандомный файлик:

```bash
[root@client ~] ll /mnt/upload/
total 0
[root@client ~] touch /mnt/upload/testfile
[root@client ~] ll /mnt/upload/
total 0
-rw-r--r--. 1 nfsnobody nfsnobody 0 Apr  3 12:03 testfile
```

Заходим на **server** и проверяем наличие файлика:

```bash
[vagrant@server ~]$ ll /var/upload/
total 0
-rw-r--r--. 1 nfsnobody nfsnobody 0 Apr  3 12:03 testfile
```

Проверяем то, что работаем по upd. Для этого создаем файл на **client** и tcpdump на server проверяем:

```bash
[root@server ~]# tcpdump -i eth1 udp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), capture size 262144 bytes
12:06:17.854167 IP 192.168.0.1.db-lsp-disc > 192.168.0.255.db-lsp-disc: UDP, length 132
12:06:26.964273 IP 192.168.0.101.iris-xpc > server.nfs: NFS request xid 4293363537 108 access fh Unknown/0100070076220006000000008AC075E311244BB6BEF7A6811BF8B870 NFS_ACCESS_READ|NFS_ACCESS_LOOKUP|NFS_ACCESS_MODIFY|NFS_ACCESS_EXTEND|NFS_ACCESS_DELETE
12:06:26.965448 IP server.nfs > 192.168.0.101.iris-xpc: NFS reply xid 4293363537 reply ok 120 access c 001f
12:06:26.966565 IP 192.168.0.101.iris-xpc > server.nfs: NFS request xid 15238993 120 lookup fh Unknown/0100070076220006000000008AC075E311244BB6BEF7A6811BF8B870 "newtestfile"
12:06:26.966735 IP server.nfs > 192.168.0.101.iris-xpc: NFS reply xid 15238993 reply ok 116 lookup ERROR: No such file or directory
12:06:26.967929 IP 192.168.0.101.iris-xpc > server.nfs: NFS request xid 32016209 152 create fh Unknown/0100070076220006000000008AC075E311244BB6BEF7A6811BF8B870 "newtestfile"
12:06:26.971127 IP server.nfs > 192.168.0.101.iris-xpc: NFS reply xid 32016209 reply ok 280 create fh Unknown/0100078176220006000000008AC075E311244BB6BEF7A6811BF8B87077220006
12:06:26.972450 IP 192.168.0.101.iris-xpc > server.nfs: NFS request xid 48793425 144 setattr fh Unknown/0100078176220006000000008AC075E311244BB6BEF7A6811BF8B87077220006
12:06:26.975482 IP server.nfs > 192.168.0.101.iris-xpc: NFS reply xid 48793425 reply ok 144 setattr
12:06:47.862416 IP 192.168.0.1.db-lsp-disc > 192.168.0.255.db-lsp-disc: UDP, length 132
```
Все работае.

