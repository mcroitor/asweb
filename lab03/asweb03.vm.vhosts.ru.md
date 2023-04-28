# Лабораторная работа № 3: Настройка виртуальных хостов.

Целью данной работы является обучение добавлению и настройке сайтов (виртуальных хостов). Также студент ознакомиться со способами установки сайтов.

## Подготовка

Запустите виртуальную машину, полученную в _лабораторной работе 1_ и зайдите в неё.

## Выполнение

Установите LAMP в виртуальной машине . _Какие команды вы для этого использовали?_

Скачайте [СУБД  PhpMyAdmin](http://phpmyadmin.net/). для скачивания можно воспользоваться _curl_, _wget_ или консольными браузерами _lynx_, _links_.

Скачайте [CMS Drupal](https://www.drupal.org/).

Распакуйте скачанные файлы в папки:
1. СУБД PhpMyAdmin ==> `/home/www/phpmyadmin`;
2. CMS Drupal ==> `/home/www/drupal`.

Создайте через командную строку для CMS базу данных `drupal_db` и пользователя базы данных с вашим именем.

В папке `/etc/apache2/sites-available` создайте файл `01-phpmyadmin` с содержимым:

```
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot "/home/www/phpmyadmin"
    ServerName phpmyadmin.localhost
    ServerAlias www.phpmyadmin.localhost
    ErrorLog "/tmp/phpmyadmin.localhost-error.log"
    CustomLog "/tmp/phpmyadmin.localhost-access.log" common
</VirtualHost>
```

В папке `/etc/apache2/sites-available` создайте файл `02-drupal` с содержимым:

```
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot "/home/www/drupal"
    ServerName drupal.localhost
    ServerAlias www.drupal.localhost
    ErrorLog "/tmp/drupal.localhost-error.log"
    CustomLog "/tmp/drupal.localhost-access.log" common
</VirtualHost>
```

Зарегистрируйте конфигурации, выполнив команды:
```bash
sudo a2ensite 01-phpmyadmin
sudo a2ensite 02-drupal
```

## Запуск и тестирование

Перегрузите Apache Web Server:

```shell
systemctl reload apache2
```

В браузере проверьте доступность сайтов  `http://drupal.localhost` и `http://phpmyadmin.localhost`. Завершите установку сайтов.
    
## Отчет

Предоставьте отчет о проделаной работе.

Ответьте на следующие вопросы:

1. Каким образом можно скачать файл в консоли при помощи утилиты curl?
2. Зачем необходимо создавать для каждого сайта свою базу и своего пользователя?
3. Как поменять доступ к системе управления БД на порт `1234`?

