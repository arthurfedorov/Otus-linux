# Web сервера

## Домашнее задание

Простая защита от DDOS
Цель: Разобраться в базовых принципах конфигурирования nginx. Рассмотреть хорошие\плохие практики конфигурирования, настройки ssl. <https://gitlab.com/otus_linux/nginx-antiddos-example>

## Решение

1. Запустить vagrant

```bash
vagrant up
```

2. Проверим cURL'ом, работает ли редирект, если нет cookie.

```bash
curl -I localhost:8080
```

Получаем:

```bash
HTTP/1.1 302 Moved Temporarily
Server: nginx/1.16.1
Date: Sat, 07 Mar 2020 15:23:43 GMT
Content-Type: text/html
Content-Length: 145
Connection: keep-alive
Location: http://localhost:8080/bot
Set-Cookie: originUrl=http://localhost:8080/
```
Редиректнуло.

3. Проверим cURL'ом, подставив требуемую cookie.

```bash
curl -I --cookie "bot=net" localhost:8080
```
Получаем:

```bash
HTTP/1.1 200 OK
Server: nginx/1.16.1
Date: Sat, 07 Mar 2020 15:58:41 GMT
Content-Type: text/html
Content-Length: 130
Last-Modified: Sat, 07 Mar 2020 15:22:26 GMT
Connection: keep-alive
ETag: "5e63bc32-82"
Accept-Ranges: bytes
```
Код 200, все в порядке.

4. Можно проверить все ли работает в браузере перейдя по ссылке <http://localhost:8080/otus.html>