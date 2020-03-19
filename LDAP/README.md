# LDAP. Централизованная авторизация и аутентификация

## Домашнее задание

LDAP:

1. Установить FreeIPA;
2. Написать Ansible playbook для конфигурации клиента;
3*. Настроить аутентификацию по SSH-ключам;
4**. Firewall должен быть включен на сервере и на клиенте.

## Выполнение дз

1. Поднять **vagrant**:

```bash
vagrant up
```

2. Запустить playbook, который устанавливает и конфигурирует FreeIPA server и client:

```bash
ansible-playbook site.yml -vvv # можно указать любой удобный уровень verbose
```

3. Для проверки, можно зайти на машину **ipaclient**, получаем билет от сервера, вводим пароль, который указали в global переменной *{{ admin_pass }}*, в нашем случае это 12345678.

```bash
kinit admin
```

4. Проверяем что билет получен:

```bash
klist 
```

Получаем:

```bash
Ticket cache: KEYRING:persistent:0:0
Default principal: admin@TEST.LOCAL
```

5. Можно зайти на web интерфейс, для этого в */etc/hosts* необходимо прописать адрес IPA сервера.

```bash
192.168.11.150  ipaserver.test.local
```

В браузере перейти по ссылке <http://ipaserver.test.local> и аутентифицироваться под учетной записью admin / 12345678


## Полезные ссылки

- [Установка и использование FreeIPA на CentOS](https://www.dmosk.ru/miniinstruktions.php?mini=freeipa-centos)
- [ipa-server-install(1) - Linux man page](https://linux.die.net/man/1/ipa-server-install)
- [ipa-client-install(1) - Linux man page](https://linux.die.net/man/1/ipa-client-install)