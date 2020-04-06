# Description

Patroni cluster demo stand

## How-to

Run:

```
vagrant up
ansible-playbook site.yml -i hosts
```

Consul UI: `192.168.11.100:8500`

Check patroni cluster status from host: `patronictl -c /etc/patroni/patroni.yml list`

## Ansible variables

## Playbook example


1. Postgres

yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum install postgresql11-server
/usr/pgsql-11/bin/postgresql-11-setup initdb
systemctl enable postgresql-11
systemctl start postgresql-11



dep for patroni
python3-pip
python3-devel
psycopg2-binary
gcc

setuptools
python-consul