# Загрузка Linux

ДЗ состоит из нескольких подзадач.

## Попасть в систему без пароля несколькими способами

1. Первый способ описан в официальной документации Redhat, доступно по [ссылке](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-Terminal_Menu_Editing_During_Boot#proc-Resetting_the_Root_Password_Using_rd.break).

Загружаем виртуальную машину, при выборе ядра необходимо нажать на **e**
В случае если есть параметр rhgb (redhat graphical boot) и quiet (отвечает за вывод информации о загрузке ядра) удаляем их.

> [!ВАЖНО]
> Если используется Virtualbox в качестве среды виртуализации, необходимо в настройках загрузки ядра удалить параметр **console=ttyS0,115200n8**

Добавляем в конце строки, начинающийся с linux16 параметр **rd.break enforcing=0**. Параметр **enforcing=0** отключает SELinux и освобождает от необходимости переназначения меток selinux. Далее нажимаем **Ctrl+x** для загрузки системы

/sysroot примонтируется в read-only режиме. Необходимо изменить на rw, иначе не удастся сменить пароль у root.

```bash
# mount -o remount,rw /sysroot
```

Файловая система примонтирована в rw. Далее чрутнемся:

```bash
# chroot /sysroot
```

Меняем пароль у root, командой **passwd**. Далее выходим из чрута и дальнейшей загрузки в систему, два раза введя **exit**. Все, можно заходить под новым паролем.
Так как мы добавили **enforcing=0** в предыдущем шаге, необходимо восстановить **/etc/shadow**

```bash
# restorecon /etc/shadow
```

Возвращаем SELinux

```bash
# setenforce 1
# getenforce
```

2. Следующий способ изменения root пароля - аналогичен предыдущему, за исключением того, что в конце строки конфигурации загрузки ядра добавляется:

```bash
# rw init=/bin/bash
```

Загружаемся **ctrl+x**
Теперь можно изменить пароль у root

```bash
# echo qwerty  |  passwd --stdin  root
```

Релейбл SELinux после следующей загрузки

```bash
# touch /.autorelabel
```

Запускаем дальнейшую загрузку системы

```bash
# exec /sbin/init
```

Заходим под новым паролем

## Установить систему с LVM, после чего переименовать VG

- Запускаем машину командой

```bash
# vagrant up
```

У меня крайне слабый bash скриптинг, поэтому работа будет описана в README. Предполагаю, что всю ручную работу можно было переложить на sed/awk.
Образ Vagrant машины был взят с домашнего задания по LVM. В provision была добавлена команда, которая переименовывает Volume группу **vgrename $(vgs --noheadings -o vg_name | tr -d ' ') OtusRoot**.
Далее исправляем все пути старой Volume группы на новую в файлах */etc/fstab, /etc/default/grub, /boot/grub2/grub.cfg*.
После чего пересобираем initrd образ, чтобы при загрузке системы не было проблем.

```bash
# mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
```

**Creating image file done** говорит нам о том, что образ собрался и можно перезагружаться для проверки, делаем **reboot**.
Проверяем, что после ребута ничего не сломалось.

```bash
# vgs
```

Должны увидеть, что Volume группа переименовалась в OtusRoot.

```bash
[root@lvm ~]# vgs
  VG       #PV #LV #SN Attr   VSize   VFree
  OtusRoot   1   2   0 wz--n- <38.97g    0
```

## Добавить модуль в initrd

Честно говоря, не нашел особого применения для данного функционала, поэтому бездумно прошелся по методичке и установил Tux'a на загрузку.

Создаем папку 01test в */usr/lib/dracut/modules.d/*

```bash
# mkdir /usr/lib/dracut/modules.d/01test
```

В нее складываем два скрипта **module-setup.sh** и **test.sh**. Содержимое этих скриптов ниже.

```bash
# cat module-setup.sh

!/bin/bash

check() {
    return 0
}

depends() {
    return 0
}

install() {
    inst_hook cleanup 00 "${moddir}/test.sh"
}
```

```bash
# cat test.sh

#!/bin/bash

exec 0<>/dev/console 1<>/dev/console 2<>/dev/console
cat <<'msgend'
Hello! You are in dracut module!
 ___________________
< I'm dracut module >
 -------------------
   \
    \
        .--.
       |o_o |
       |:_/ |
      //   \ \
     (|     | )
    /'\_   _/`\
    \___)=(___/
msgend
sleep 10
echo " continuing...."
```

Пересобираем образ initrd

```bash
# mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
```

Проверяем, что наш модуль загружен в образ

```bash
lsinitrd -m /boot/initramfs-$(uname -r).img | grep test
```

Правим /boot/grub2/grub.cfg и удаляем оттуда параметры *quiet* и *rhgb*. После чего перезагружаемся и в GUI VirtualBox, при загрузке системы видим Tux'a.