# Управление пакетами. Дистрибьюция софта

>Размещаем свой RPM в своем репозитории
>
>1. Cоздать свой RPM (можно взять свое приложение, либо собрать к примеру апач с определенными опциями)
>2. Cоздать свой репо и разместить там свой RPM реализовать это все либо в вагранте, либо развернуть у себя через nginx и дать ссылку на репо

## Cоздать свой RPM

В первую очередь установим необходимые для работы пакеты:

```bash
# yum install -y wget git epel-release yum-utils rpm-build createrepo
```

Скачиваем src пакет nginx. Данная версия была выбрана в связи с тем, что модуль [sysguard](https://github.com/vozlt/nginx-module-sysguard), защищающий систему от highload нагрузки адекватно работает на данной версии (судя по странице на GitHub):

```bash
# wget http://nginx.org/packages/mainline/centos/7/SRPMS/nginx-1.11.10-1.el7.ngx.src.rpm
```

Склонируем модуль sysguard из репозитория на GitHub:

```bash
# git clone git://github.com/vozlt/nginx-module-sysguard.git
```

Устанавливаем пакет, после чего в home директории создастся дерево каталогов, необходимое для сборки:

```bash
# rpm -Uhv nginx-1.11.10-1.el7.ngx.src.rpm
```

Установим зависимости, которые могут понадобится nginx:

```bash
# yum-builddep -y rpmbuild/SPECS/nginx.spec
```

Правим конфигурационный файл билда nginx, добавляем *--add-module=/path/to/nginx-module-sysguard*. Должно получится что-то подобное:

>%build
>./configure %{BASE_CONFIGURE_ARGS} \
> --with-cc-opt="%{WITH_CC_OPT}" \
> --with-ld-opt="%{WITH_LD_OPT}" \
> --with-debug \
> --add-module=/home/lunnyj/nginx-module-sysguard

Запускаем сборку пакета:

```bash
# rpmbuild -bb rpmbuild/SPECS/nginx.spec
```

Если все пройдет гладко, то должны появится два пакета:

```bash
ll rpmbuild/RPMS/x86_64/
total 3004
-rw-rw-r--. 1 lunnyj lunnyj  740860 Jan  8 23:02 nginx-1.11.10-1.el7.ngx.x86_64.rpm
-rw-rw-r--. 1 lunnyj lunnyj 2333232 Jan  8 23:02 nginx-debuginfo-1.11.10-1.el7.ngx.x86_64.rpm
```

Установим собранный nginx и запустим его:

```bash
# yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.11.10-1.el7.ngx.x86_64.rpm
# systemctl enable nginx
# systemctl start nginx
```

Проверить что nginx установился, можно сделава **curl localhost**.

## Cоздать свой репо и разместить там свой RPM

Создаем каталог repo в дефолтном каталоге статики nginx:

```bash
# mkdir -p /usr/share/nginx/html/repo
```

Кладем в каталог наш собранный nginx и пакет из методчки Percona-Server:

```bash
# cp rpmbuild/RPMS/x86_64/nginx-1.11.10-1.el7.ngx.x86_64.rpm /usr/share/nginx/html/repo
# wget https://www.percona.com/redir/downloads/percona-release/redhat/percona-release-1.0-13.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-1.0-13.noarch.rpm
```

Инициализируем репозиторий:

```bash
# createrepo /ush/share/nginx/html/repo
```

Сделаем reload nginx для того чтобы применились новые настройки:

```bash
# systemctl reload nginx
```

Приватный репозиторий доступен по ссылке <http://194.87.239.178/repo/>

### TO-DO

- Разобраться с запуском в Vagrant, почему-то возникают проблемы с директориями установки пакета через rpm -Uhv

- Разобраться что требуется сделать с Docker
