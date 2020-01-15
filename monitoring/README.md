# Мониторинг и алертинг

## Домашнее задание

Настройка мониторинга, дашборд с 4-мя графиками

- память

- процессор

- диск

- сеть

Задание со * использование систем примеры которых не рассматривались на занятии

### Выполнение

В качестве системы мониторинга был выбран стек prometheus и grafana, а также различные exporter для сбора метрик с машин и сервисов.

Конфигурация docker-compose ниже:

```yaml
version: '3.7'

networks:
  monitor-net:
    driver: bridge

volumes:
    prometheus_data: {}
    grafana_data: {}

services:

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    volumes:
      - ./prometheus:/etc/prometheus
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention.time=200h'
      - '--web.enable-lifecycle'
    restart: unless-stopped
    expose:
      - 9090
    ports:
      - 9090:9090
    networks:
      - monitor-net

  nodeexporter:
    image: prom/node-exporter:latest
    container_name: nodeexporter
    user: root
    privileged: true
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.ignored-mount-points=^/(sys|proc|dev|host|etc)($$|/)'
    restart: unless-stopped
    expose:
      - 9100
    ports:
      - 9100:9100
    networks:
      - monitor-net

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    volumes:
        - grafana_data:/var/lib/grafana
        - ./grafana/datasources:/etc/grafana/datasources
        - ./grafana/dashboards:/etc/grafana/dashboards
        - ./grafana/setup.sh:/setup.sh
    environment:
      - GF_SECURITY_ADMIN_USER=${ADMIN_USER:-admin}
      - GF_SECURITY_ADMIN_PASSWORD=${ADMIN_PASSWORD:-admin}
      - GF_USERS_ALLOW_SIGN_UP=false
    restart: unless-stopped
    expose:
      - 3000
    ports:
      - 3000:3000
    networks:
      - monitor-net
```

Для запуска стека необходимо установить docker и бинарник docker-compose. Инструкция по установке находится на [официальном сайте](https://docs.docker.com/install/linux/docker-ce/centos/). После чего в директории с docker-compose.yml, запускаем

```bash
docker-compose up -d
```

На удаленном машине, которую мониторим, устанавливаем [node-exporter](https://github.com/prometheus/node_exporter), для сборки основных метрик по заданию - *CPU, RAM, Network, disk*.

```bash
docker run -d -p 9100:9100 prom/node-exporter
```

Метрики доступны по адресу <http://194.87.239.178:9100/metrics>

Для мониторинга основных метрик nginx, который был развернут для [домашнего задания](https://github.com/lunnyj/Linux-Administrator-Course/tree/master/rpm) по созданию собственного репозитория установим [nginx-prometheus-exporter](https://github.com/nginxinc/nginx-prometheus-exporter)

```bash
docker run -d -p 9113:9113 --network host nginx/nginx-prometheus-exporter:0.5.0 -nginx.scrape-uri "http://localhost:80/nginx_status"
```

Метрики nginx доступны по адресу <http://194.87.239.178:9113/metrics>

Также на машине установлен PostgreSQL 9.6, с тестовой базой PostgresPro <https://postgrespro.ru/education/demodb>. Для мониторинга состояния базы, установим [postgres_exporter](https://github.com/wrouesnel/postgres_exporter).

```bash
docker run -d --net=host -e DATA_SOURCE_NAME="postgresql://postgres:postgres@127.0.0.1:5432/demo?sslmode=disable" wrouesnel/postgres_exporter
```

Метрики PostgreSQL доступны по адресу <http://194.87.239.178:9187/metrics>.

Grafana доступна по адресу <http://http://84.201.158.85:3000/,> учетка otus_monitoring / otus_monitoring. Мониторится виртуальная машина с nginx и postgresql на борту.

Собраны несколько дашбордов - со сбором метрик по домашнему заданию.

![photo](Pictures/node_exporter.png)

При желании, можно посмотреть на дашборды nginx и PostgreSQL. 

### TO-DO

- Развернуть zabbix

- Посмотреть альтернативы, которые указаны в презентации
