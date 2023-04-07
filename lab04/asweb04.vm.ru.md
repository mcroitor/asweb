# Лабораторная работа № 4: Обслуживание сервера

Целью данной работы является обучение обслуживанию серверов.

## Подготовка

Запустите виртуальный сервер (LL Nr. 3)

## Выполнение

### Создание администратора сайта

Подключитесь к виртуальному серверу по SSH (putty или ssh).

Создайте пользователя системы `webadmin`, в группе `webadmin`.

Дайте данному пользователю права владельца на директорию `/home/www/drupal`.

### Резервное копирование

В папке `/var/` создайте папку `backups/`, а в ней папки `mysql/` и `site/`.

Создайте в менеджере задач cron следующие задачи:

1. каждые 24 часа создаётся резервная копия базы данных CMS
2. каждый понедельник создаётся резервная копия директории CMS
3. Каждые 24 часа удалять резервные копии, которые были созданы 30 дней назад.

Для этого выполните команду

```shell
crontab -e
```

и в открывшемся редакторе пропишите (прописав соответсвующие логин и пароль пользователя базы данных)

```
# dump sql database
0 1 * * * mysqldump -u <username> -p<password> drupal_db | gzip > /var/backups/mysql/drupal_db_$(date +\%Y\%m\%d).sql.gz
# backup site
0 2 * * 1 tar czf /var/backups/site/drupal_$(date +\%Y\%m\%d).tar.gz /home/www/drupal
0 3 * * * find /var/backups/mysql -type f -mtime +30 -exec rm {} \;
0 4 * * * find /var/backups/site -type f -mtime +30 -exec rm {} \;
```

### Ротация логов

Проверьте, если в системе установлена утилита `logrotate` командой

```shell
logrotate -v
```

Если программа не найдена, установите её из репозитория.

```shell
apt update && apt install logrotate
```

Перейдите в папку `/etc/logrotate.d` и создайте в ней файл `httpdlog.conf` со следующим содержимым:

```
/var/log/apache2/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 640 root webadmin
    sharedscripts
    postrotate
        /etc/init.d/apache2 reload > /dev/null
    endscript
    prerotate
        if [ -d /etc/logrotate.d/httpd-prerotate ]; then \
            run-parts /etc/logrotate.d/httpd-prerotate; \
        fi; \
    endscript
}
```

Зарегистрируйте ротацию логов в cron. Для это создайте в пепке `/etc/cron.daily` файл `logrotate` со следующим содержимым:

```shell
#!/bin/sh

/usr/sbin/logrotate /etc/logrotate.conf
```

Выполните команду:

```shell
sudo chmod +x /etc/cron.daily/logrotate
```

## Запуск и тестирование

Перезапустите Apache HTTP Server. Перезапустите cron.

Проверьте, может ли созданный пользователь `webadmin` работать на сервере удаленно, через ssh.

Проверьте содержимое папки `/var/log/apache2/`.  Что она содержит?

## Отчет

Предоставьте отчет о проделаной работе.

Ответьте на вопросы:

1. Какой адрес IP показывает команда `ip address`?
2. Зачем необходимо создавать пользователя системы для каждого сайта?
3. В каких случаях Web сервер должен иметь полный доступ к папкам (папке) сайта?
4. Что означает команда `chmod -R 0755 /home/www/anydir`?
5. Что делает команда `sudo chmod +x /etc/cron.daily/logrotate` ?