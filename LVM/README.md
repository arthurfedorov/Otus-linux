# Домашнее задание по LVM

Выполняется на основе методичке, приложенной к уроку, поэтому "открытий века" ждать не стоит.

Vagrantfile cкачан с [https://gitlab.com/otus_linux/stands-03-lvm/blob/master/Vagrantfile](репозитория)
Далее стандартно:

```bash
vagrant up
```

Заходим на машину.Смотрим на имеющиеся устройства и файловые системы на них (если таковы имеются):

```bash
lsblk -f
```

Видим диски **sdb**,**sdc**,**sdd**,**sde**.

## Уменьшить том под / до 8 Gb

Для начала зайдем под root:

```bash
sudo -i
```

1. Установить утилиту **xfsdump**, с помощью которой будем снимать копию тома /.

```bash
yum install xfsdump -y
```

2. Инициализируем диск:

```bash
# pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
```

3. Создаем группу томов с названием *vg_root*:

```bash
# vgcreate vg_root /dev/sdb
  Volume group "vg_root" successfully created.
```

4. Создаем логическую группу томов и задействуем весь объем доступной памяти:

```bash
# lvcreate -n lv_root -l +100%FREE /dev/vg_root
  Logical volume "lv_root" created.
```

5. Создаем файловую систему xfs, для того чтобы в дальнейшем перенести на нее **/**:

```bash
# mkfs.xfs /dev/vg_root/lv_root
```

6. Монтируем раздел в */mnt*

```bash
# mount /dev/vg_root/lv_root /mnt
```

7. С помощью ранее установленной утилиты **xfsdump**, копируем информацию на смонтированный раздел:

```bash
# xfsdump -J - /dev/VolGroup00/LogVol00 | xfsrestore -J - /mnt
   xfsrestore: Restore Status: SUCCESS
```

Успешность копирования можно проверить командой ls -l /mnt. Должен быть вывод аналогичный выводу ls -l /

8. Необходимо переконфигурировать grub, чтобы при старте системы запуск происходил из вновь созданного корня

```bash
# for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
```

9. Чрутимся

```bash
# chroot /mnt/
```

10. Обновим grub для загрузки из нового раздела

```bash
# grub2-mkconfig -o /boot/grub2/grub.cfg
```

11. Обновляем образ initrd

```bash
# cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g; s/.img//g"` --force; done
```

12. Чтобы при загрузке был смонтирован нужный root нужно в файле /boot/grub2/grub.cfg заменить rd.lvm.lv=VolGroup00/LogVol00 на rd.lvm.lv=vg_root/lv_root

13. Выходим из chroot командой **exit**, перезагружаемся. Проверяем что все загрузка произошла с нового тома командой **lsblk**

14. Теперь необходимо уменьшить размер старой volume group и перенести root на этот измененный том.

14. Удаляем старый logical volume

```bash
# lvremove /dev/VolGroup00/LogVol00
```

15. Создаем новый logical volume

```bash
# lvcreate -n VolGroup00/LogVol00 -L 8G /dev/VolGroup00
```

16. Создаем файловую систему, монтируем и копируем из lv_root корень.

```bash
# mkfs.xfs /dev/VolGroup00/LogVol00
# mount /dev/VolGroup00/LogVol00 /mnt
# xfsdump -J - /dev/vg_root/lv_root | xfsrestore -J - /mnt
```

17. Переконфигурируем новый grub файл

```bash
# for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
# chroot /mnt/
# grub2-mkconfig -o /boot/grub2/grub.cfg
```

18. Обновляем образ initrd

```bash
# cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g; s/.img//g"` --force; done
```

## Создание нового lv под /var и зеркалируем

1. На дисках **/dev/sdc** и **/dev/sdd** создаем зеркало

```bash
# pvcreate /dev/sdc /dev/sdd
# vgcreate vg_var /dev/sdc /dev/sdd
# lvcreate -L 950M -m1 -n lv_var vg_var
```

2. Создаем файловую систему на зеркале, монтируем раздел в **/mnt** и rsync'ом тянем все из текущего раздела /var

```bash
# mkfs.ext4 /dev/vg_var/lv_var
# mount /dev/vg_var/lv_var /mnt
# rsync -avHPSAX /var/ /mnt/
```

3. Монтируем новый var в каталог **/var**:

```bash
# umount /mnt
# mount /dev/vg_var/lv_var /var
```

4. Правим fstab. Воспользовался ручным способом поиска UUID зеркала **blkid**, так как не понял конструкцию с awk

5. Перезагружаем систему, после чего удаляем раннее созданый временный раздел volume group root

```bash
# lvremove /dev/vg_root/lv_root
# vgremove /dev/vg_root
# pvremove /dev/sdb
```

## Создание нового тома под раздел /home

1. Создаем logical volume, файловую систему и копируем файлы из существующей папки /home

```bash
# lvcreate -n LogVol_Home -L 2G /dev/VolGroup00
# mkfs.xfs /dev/VolGroup00/LogVol_Home
# mount /dev/VolGroup00/LogVol_Home /mnt/
# rsync -avHPSAX /home/ /mnt/
# rm -rf /home/*
# umount /mnt
# mount /dev/VolGroup00/LogVol_Home /home/
```

2. Правим fstab. Воспользовался ручным способом поиска UUID зеркала **blkid**, так как не понял конструкцию с awk

## Работа со lvm snapshot

1. Генерируем файлы для последующего удаления и восстановления

```bash
# touch /home/file{1..20}
```

2. Снимаем snapshot

```bash
# lvcreate -L 100MB -s -n home_snap /dev/VolGroup00/LogVol_Home
```

3. Удаляем часть файлов и проверяем что действительно удалились

```bash
# rm -f /home/file{11..20}
# ls -all /home/
```

4. Восстанавливаем файлы из snapshot

```bash
# umount /home
# lvconvert --merge /dev/VolGroup00/home_snap
# mount /home
```