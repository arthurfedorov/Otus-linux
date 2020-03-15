# Сетевые пакеты. VLAN'ы. LACP

## Домашнее задание

строим бонды и вланы
в Office1 в тестовой подсети появляется сервера с доп интерфесами и адресами
в internal сети testLAN

- testClient1 - 10.10.10.254
- testClient2 - 10.10.10.254
- testServer1- 10.10.10.1
- testServer2- 10.10.10.1

равести вланами
testClient1 <-> testServer1
testClient2 <-> testServer2

между centralRouter и inetRouter
"пробросить" 2 линка (общая inernal сеть) и объединить их в бонд
проверить работу c отключением интерфейсов

## Выполнение

1. Для проверки домашнего задания, необходимо поднять машины командой:

```bash
vagrant up
```

2. Запустить playbook:

```bash
ansible-playbook main.yml -vvv
```

Можно попинговать с testClient1 testServer1 и наоборот. Для проверки бондинга, ifdown eth1 на centralRouter или inetRouter, коннект не потеряется.