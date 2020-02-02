#!/bin/sh
set -e
export BORG_PASSPHRASE="testingborg"
borg create --compression lzma,2 root@192.168.110.101:/root/backup_repository::etc_backup-{now:%Y-%m-%d_%H:%M:%S} /etc