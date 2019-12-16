# Docker и docker-compose

TODO:
- Закончить задание со звездочкой.

## Создание каcтомного образа nginx на базе дистрибутива Alpine.

Для запуска образа nginx, необходимо запуллить его с **Dockerhub** командой:

```bash
docker pull lunnyj/nginx_for_otus
```

Убедиться в том, что все скачалось можно командой *docker images*.
Далее запускаем контейнер из скаченного образа, забиндим 80-ый порт на хостовой машине с 80-ым портом гостевой (если 80-ый порт у вас занят, необходимо использовать свободный)

```bash
docker run -d -p 80:80 lunnyj/nginx_for_otus
```

Убедимся, что nginx поднялся и доступен, перейдя на страницу localhost, появится кастомная страница о доступности nginx.

Далее более подробно распишем, что было сделано в рамках работы.

1. Создаем Dockerfile со следующими свойствами:

```bash
FROM alpine:3.7

RUN apk --no-cache add nginx
RUN adduser -D -g 'www' www
RUN mkdir /www \
    && mkdir -p /run/nginx
RUN chown -R www:www /var/lib/nginx \
    && chown -R www:www /www
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /www/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

2. Собираем образ командой:

```bash
docker build -t dockerhub_login/reponame:ver .
```

3. Получаем образ, готовый для загрузки в registry **Dockerhub**

4. Залогинимся в **Dockerhub** для загрузки:

```bash
docker login -u "myusername" -p "mypassword" docker.io
```

5. Загружем созданный образ:

```bash
docker push dockerhub_login/reponame:ver
```
Готово.

## Создание docker-compose с nginx и php-fpm
