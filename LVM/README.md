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

## Уменьшить том под / до 8 Gb.
Для начала зайдем под root:
```bash
sudo -i
```
1. Установить утилиту **xfsdump**, с помощью которой будем снимать копию тома /.
```bash
yum install xfsdump -y
```
1. Инициализируем диск:
```bash
# pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
```
1. Создаем группу томов с названием *vg_root*:
```bash
# vgcreate vg_root /dev/sdb
  Volume group "vg_root" successfully created.
```
1. Создаем логическую группу томов и задействуем весь объем доступной памяти:
```bash
# lvcreate -n lv_root -l +100%FREE /dev/vg_root 
  Logical volume "lv_root" created.
```
1. Создаем файловую систему xfs, для того чтобы в дальнейшем перенести на нее **/**:
```bash
# mkfs.xfs /dev/vg_root/lv_root
```
1. Монтируем раздел в */mnt*
```bash
# mount /dev/vg_root/lv_root /mnt
```
1. С помощью ранее установленной утилиты **xfsdump**, копируем информацию на смонтированный раздел:
```bash
# xfsdump -J - /dev/VolGroup00/LogVol00 | xfsrestore -J - /
   xfsrestore: Restore Status: SUCCESS
```
Успешность копирования можно проверить командой ls -l /mnt. Должен быть вывод аналогичный выводу ls -l /
1. 
