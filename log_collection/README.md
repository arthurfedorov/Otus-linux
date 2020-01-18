# Сбор и анализ логов

## Домашнее задание

>Настраиваем центральный сервер для сбора логов в вагранте поднимаем 2 машины web и log. На web поднимаем nginx на log настраиваем центральный лог сервер на любой системе на выбор
>- journald
>- rsyslog
>- elk
>настраиваем аудит следящий за изменением конфигов нжинкса
>- Все критичные логи с web должны собираться и локально и удаленно
>- Все логи с nginx должны уходить на удаленный сервер (локально только критичные)
>- Логи аудита должны также уходить на удаленную систему

> Задание со * развернуть еще машину elk
>и таким образом настроить 2 центральных лог системы elk И какую либо еще
>в elk должны уходить только логи нжинкса
>во вторую систему все остальное
>Критерии оценки: 4 - если присылают только логи скриншоты без вагранта
>5 - за полную настройку
>6 - если выполнено задание со звездочкой

## 
packages 
sudo yum install -y epel-release yum-utils vim

SHELL provising

cat >> /etc/yum.repos.d/nginx.repo <<EOL
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOL

sudo yum install -y nginx
sudo yum install -y rsyslog

systemctl enable nginx
systemctl start nginx