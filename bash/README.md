# Bash, awk, sed, grep и другие

Пишем скрипт, написать скрипт для крона, который раз в час присылает на заданную почту:

- X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
- Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
- все ошибки c момента последнего запуска
- список всех кодов возврата с указанием их кол-ва с момента последнего запуска

в письме должно быть прописан обрабатываемый временной диапазон
должна быть реализована защита от мультизапуска
Критерии оценки:
трапы и функции, а также sed и find +1 балл

## Выполнение

Ниже представлен вывод сообщения из /var/spool/mail/vagrant:

```bash
To: otus@wmotus.ru
Subject: nginx logs parser
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20200318082254.80F4C130@bash.localdomain>
From: vagrant@bash.localdomain (vagrant)


Log start from [14/Aug/2019:04:12:10 to [15/Aug/2019:00:25:46

10 IP addresses (with the largest number of requests) indicating the number of requests since the last time the script was run
      1 157.55.39.73
      1 157.55.39.179
      1 157.55.39.178
      1 141.8.141.135
      1 128.14.136.18
      1 123.136.117.238
      1 122.228.19.80
      1 118.139.177.119
      1 104.152.52.35
      1 103.240.249.197

10 requested addresses (with the largest number of requests) indicating the number of requests since the last time the script was run
      1 /2017/01/
      1 /2016/12/14/virtualenv-%D0%B4%D0%BB%D1%8F-%D0%BF%D0%BB%D0%B0%D0%B3%D0%B8%D0%BD%D0%BE%D0%B2-python-scrappy-%D0%BF%D1%80%D0%BE%D0%B5%D0%BA%D1%82-%D0%BD%D0%B0-debian-jessie/
      1 /2016/12/05/%D0%BC%D0%B8%D0%B3%D1%80%D0%B0%D1%86%D0%B8%D1%8F-noncdb-%D0%B2-pdb/
      1 /2016/12/
      1 /2016/11/03/backup-%D0%BD%D0%B0-google-drive/
      1 /2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/
      1 /2016/10/26/%D0%A1%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D0%B5-%D0%BF%D1%80%D0%BE%D0%B1%D0%BB%D0%B5%D0%BC%D1%8B-%D1%81-%D0%B7%D0%B0%D0%BF%D1%83%D1%81%D0%BA%D0%BE%D0%BC-crs/
      1 /2016/10/17/%D0%9F%D1%80%D0%BE%D0%B4%D0%BE%D0%BB%D0%B6%D0%B0%D0%B5%D0%BC-%D1%8D%D0%BA%D1%81%D0%BF%D0%B5%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-%D1%81-lacp/
      1 /2016/10/11/%D0%BC%D0%B8%D0%B3%D1%80%D0%B0%D1%86%D0%B8%D1%8F-%D0%B8%D0%B7-11g-%D0%B2-%D0%BA%D0%BE%D0%BD%D1%82%D0%B5%D0%B9%D0%BD%D0%B5%D1%80-12%D1%81/
      1 /2016/10/03/%D0%BF%D0%BE%D0%B4%D0%B3%D0%BE%D1%82%D0%BE%D0%B2%D0%BA%D0%B0-%D0%BA-%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B5-oracle-12%D1%81-%D0%BD%D0%B0-centos-7/

All errors since the last launch
     51 404
      7 400
      3 500
      2 499
      1 405
      1 403

A list of all return codes indicating their number since the last launch
    498 200
     95 301
     51 404
     11 "-"
      7 400
      3 500
      2 499
      1 405
      1 403
      1 304


--80F4C130.1584519775/bash.localdomain--
```
