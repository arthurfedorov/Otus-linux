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
