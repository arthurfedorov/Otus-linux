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

1. Поднимаем стенд:

```bash
vagrant up
```

2. Запускаем playbook:

```bash
ansible-playbook provision.yml -vvv
```

3. Проверяем работу nginx с хостовой машины, перейдя по ссылке <http://127.0.0.1:8080>

4. Для проверки Knocking port зайдем на машину **centralRouter** и запустим bash скрипт:

```bash
/usr/bin/knock.sh 192.168.255.1 8881 7777 9991
```

После чего у нас будет 30 секунд на то, чтобы зайти на **inetRouter**. Пароль стандартный для пользователя vagrant - *vagrant*:

```bash
ssh vagrant@192.168.255.1
```

## Полезные ссылки

1. [Учебник по iptables](https://binarylife.ru/iptables-u32-uchebnik/)

2. [Руководство по iptables (Iptables Tutorial 1.1.19)](https://www.opennet.ru/docs/RUS/iptables/) - толкое руководство
