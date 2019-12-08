# Переписать основной скрипт запуска JIRA на systemd unit.

Описал несколько путей того, как можно проверить выполнение дз. Первое это текстовое описание, второй - автоматическая сборка и запуск машины с JIRA.

## Установка ручками

1. В первую очередь запускаем vagrant машину, как и раньше, командой:

```bash
vagrant up
```

2. Устанавливаем wget для загрузки пакета с JIRA:

```bash
sudo yum install -y wget
```

3. Устанавливаем JAVA 8, для того чтобы JIRA взлетела:

```bash
sudo yum install -y java-1.8.0-openjdk
```

4. Прописываем в переменную JAVA_HOME путь до JAVA окружения. Вероятно можно было бы это сделать какой-нибудь регуляркой вытащив из конфигов, но разобраться с этим я пока не могу. Запишу себе в TODO.
**Добавлено**. Как оказалось необязательно, прекрасно и без этого запускается.

```bash
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.232.b09-0.el7_7.x86_64/jre/bin/java
```

6. Создадим каталог куда будет установлена JIRA

```bash
sudo mkdir -p atlassian/jirasoftware
```

7. Скачаем архив JIRA

```bash
wget https://downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-8.5.1.tar.gz
```

8. Распаковываем архив в созданный каталог:

```bash
tar -xzf atlassian-jira* -C atlassian/jirasoftware/ --strip 1
```

9. Создаем каталог для логов и кэшей JIRA, без нее не запустится установка

```bash
mkdir atlassian/jirahome
```

10. Прописываем в конфигах JIRA путь до папки с кэшами. 
**Добавлено**.Как оказалось необязательно, прекрасно и без этого запускается.

```bash
echo "jira.home=/home/vagrant/atlassian/jirahome" > /home/vagrant/atlassian/jirasoftware/atlassian-jira/WEB-INF/classes/jira-application.properties
```

11. Создаем UNIT командой **sudo touch /etc/systemd/system/jira.service**, открываем любым текстовым редактором и вставляем:

```markdown
[Unit] 
Description=Atlassian Jira
After=network.target

[Service] 
Type=forking
User=vagrant
PIDFile=/home/vagrant/atlassian/jirasoftware/work/catalina.pid
ExecStart=/home/vagrant/atlassian/jirasoftware/bin/start-jira.sh
ExecStop=/home/vagrant/atlassian/jirasoftware/bin/stop-jira.sh

[Install] 
WantedBy=multi-user.target
```

12. Релоадим демона

```bash
sudo systemctl daemon-reload
```

13. Cоздаем линку, но надо ли? Учитывая что создавал UNIT файл в /etc/systemd/system/

```bash
sudo systemctl enable jira
```

14. Запускаем сервис

```bash
sudo systemctl start jira
```
15. Переходим на хост машине по адресу http://localhost:8090 и попадаем на страницу конфигурации JIRA.

## Provisioning через Vagrant. Автоматическая сборка

Необходимо склонировать приложенный Vagrantfile и папку scripts(должная находится в одном каталоге с Vagrantfile). В нем лежит UNIT файл. После стандартного **vagrant up** произойдет сборка и запуск приложения.
Для проверки того, что все работает, необходимо перейти на хост машине по адресу http://localhost:8090