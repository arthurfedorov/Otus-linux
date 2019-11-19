# Домашнее задание по LVM
Выполняется на основе методичке, приложенной к уроку, поэтому "открытий века" ждать не стоит.

Vagrantfile cкачан с [https://gitlab.com/otus_linux/stands-03-lvm/blob/master/Vagrantfile](репозитория)
Далее стандартно:
```bash
vagrant up
```
Смотрим на имеющиеся устройства и файловые системы на них (если таковы имеется):
```bash
lsblk -f
```
Видим диски **sdb**,**sdc**,**sdd**,**sde**.

1. Уменьшить том под / до 8 Gb.
Для начала зайдем под root:
```bash
sudo -i
```
- Установить утилиту **xfsdump**, с помощью которой будем снимать копию тома /.
```bash
yum install xfsdump -y
```
- Инициализируем диск:
```bash
[root@lvm ~]# pvcreate /dev/sdb
Physical volume "/dev/sdb" successfully created.
```
