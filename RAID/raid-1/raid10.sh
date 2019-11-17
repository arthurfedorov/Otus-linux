#!/bin/bash
# Суперблоки не зануляем, так как это новые диски
mdadm --create --verbose /dev/md0 -l 10 -n 6 /dev/sd{b,c,d,e,f,g} #выбрал RAID10, по причине того, что на работе на БД используются 10-ые RAID

# Далее создаем конфигурационный файл, который говорит системе, какой создается RAID массив и какие доски в него входит
# Штука старая и уже не нужная, но по домашке сделать надо
mkdir /etc/mdadm

mdadm --detail --scan --verbose | awk'/ARRAY/{print}'>> /etc/mdadm/mdadm.conf # записываем конфиг

parted -s /dev/md0 mklabel gpt # создаем таблицу разделов GPT

# Создаем партиции на дисках
parted /dev/md0 mkpart primary ext4 0% 20%
parted /dev/md0 mkpart primary ext4 20% 40%
parted /dev/md0 mkpart primary ext4 40% 60%
parted /dev/md0 mkpart primary ext4 60% 80%
parted /dev/md0 mkpart primary ext4 80% 100%

# Форматируем партиции в файловую систему ext4 с помощью регулярного выражения
for i in $(seq 5);do sudo mkfs.ext4 /dev/md0p$i;done

# Создаем точки монтирования наших партиций и монтируем их
mkdir -p /raid/part{1,2,3,4,5}
for i in $(seq 5);do sudo mount -rw /dev/md0p$i /raid/part$i;done