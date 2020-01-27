https://docs.ansible.com/ansible/latest/modules/cron_module.html cron


1. Cтавим epel-release
2. Ставим borgbackup
3. Создаем юзера backup c group backup с home каталогом



borg create -s --progress repo::archive path 