# Динамический веб контент

## Домашнее задание

Роль для настройки веб сервера
Варианты стенда
nginx + php-fpm (laravel/wordpress) + python (flask/django) + js(react/angular)
nginx + java (tomcat/jetty/netty) + go + ruby
можно свои комбинации

Реализации на выбор:

- на хостовой системе через конфиги в /etc
- деплой через docker-compose

Для усложнения можно попросить проекты у коллег с курсов по разработке

## Выполнение

```bash
yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum install -y postgresql96 postgresql96-server postgresql96-devel
/usr/pgsql-9.6/bin/postgresql96-setup initdb
изменение pg_hba.conf
изменение postgresql.conf
systemctl start postgresql-9.6
systemctl enable postgresql-9.6
sudo -u postgres psql
CREATE DATABASE netbox;
CREATE USER netbox WITH PASSWORD 'J5brHrAXFLQSif0K';
yum install -y epel-release
yum install -y redis
systemctl start redis
systemctl enable redis
yum install -y gcc python36 python36-devel python36-setuptools libxml2-devel libxslt-devel libffi-devel openssl-devel redhat-rpm-config wget
wget https://github.com/netbox-community/netbox/archive/v2.7.10.tar.gz
tar -xzf v2.7.10.tar.gz -C /opt
добавить пользователя netbox useradd -U -r netbox
python3 -m venv /opt/netbox/venv
pip3 install -r requirements.txt
скопировать конфиг configuration.py
python3 /opt/netbox/netbox/manage.py migrate
python3 manage.py createsuperuser