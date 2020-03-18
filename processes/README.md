# Управление процессами

## Домашнее задание

работаем с процессами
Задания на выбор:

1. Написать свою реализацию ps ax используя анализ /proc
- Результат ДЗ - рабочий скрипт который можно запустить
2. Написать свою реализацию lsof
- Результат ДЗ - рабочий скрипт который можно запустить
3. Дописать обработчики сигналов в прилагаемом скрипте, оттестировать, приложить сам скрипт, инструкции по использованию
- Результат ДЗ - рабочий скрипт который можно запустить + инструкция по использованию и лог консоли
4. Реализовать 2 конкурирующих процесса по IO. пробовать запустить с разными ionice
- Результат ДЗ - скрипт запускающий 2 процесса с разными ionice, замеряющий время выполнения и лог консоли
5. Реализовать 2 конкурирующих процесса по CPU. пробовать запустить с разными nice
- Результат ДЗ - скрипт запускающий 2 процесса с разными nice и замеряющий время выполнения и лог консоли

## Выполнение

1. Реализовать 2 конкурирующих процесса по IO. пробовать запустить с разными ionice:

```bash
#!/bin/bash
time ionice -c 1 dd if=/dev/urandom of=test1.img bs=1M count=20 &
time ionice -c 3 dd if=/dev/urandom of=test3.img bs=1M count=20 &
wait
```

Вывод:

```bash
[root@ipaserver ~]# source io.sh 
20+0 records in
20+0 records out
20971520 bytes (21 MB) copied, 0.281744 s, 74.4 MB/s

real    0m0.306s
user    0m0.001s
sys     0m0.135s
[1]-  Done                    time ionice -c 1 dd if=/dev/urandom of=test1.img bs=1M count=20
20+0 records in
20+0 records out
20971520 bytes (21 MB) copied, 0.300652 s, 69.8 MB/s

real    0m0.315s
user    0m0.000s
sys     0m0.152s
[2]+  Done                    time ionice -c 3 dd if=/dev/urandom of=test3.img bs=1M count=20
```

2. Реализовать 2 конкурирующих процесса по CPU. пробовать запустить с разными nice:

```bash
#!/bin/bash

function nice_19()
{
    echo $(date) "Start process  with nice 19" 
    nice -n 19 gzip -c /boot /var /usr >/tmp/nice_19.gz >/dev/null 2>&1
}

function nice_20()
{
    echo $(date) " Start process  with nice -20"
    nice -n -20 gzip -c /boot /var /usr >/tmp/nice_20.gz >/dev/null 2>&1
}

time nice_19
time nice_20
```

Вывод:

```bash
[root@ipaserver ~]# source cpuconc.sh
Tue Mar 17 20:28:03 UTC 2020 Start process  with nice 19

real    0m0.018s
user    0m0.005s
sys     0m0.009s
Tue Mar 17 20:28:03 UTC 2020  Start process  with nice -20

real    0m0.014s
user    0m0.012s
sys     0m0.000s

```
