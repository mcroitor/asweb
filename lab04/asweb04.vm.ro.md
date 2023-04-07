# Lucrarea de laborator nr. 4: Mentenanța serverului

Scopul acestei lucrări este de a învăța mentenanța serverelor.

## Pregătire

Porniți serverul virtual (LL Nr. 3).

## Executarea

### Crearea administratorului site-ului

Conectați-vă la serverul virtual prin SSH (putty sau ssh).

Creați un utilizator de sistem `webadmin`, în grupul `webadmin`.

Dați acestui utilizator drepturile de proprietar pentru directorul `/home/www/drupal`.

### Crearea copiilor de rezervă

În folderul `/var/` creați folderul `backups/`, iar în acesta, folderele `mysql/` și `site/`.

Creați următoarele sarcini cron în managerul de sarcini:

1. o copie de rezervă a bazei de date CMS este creată la fiecare 24 de ore
2. o copie de rezervă a directorului CMS este creată în fiecare luni
3. La fiecare 24 de ore, ștergeți copiile de rezervă create acum 30 de zile.

Pentru aceasta, executați comanda

```shell
crontab -e
```

și în editorul deschis, scrieți (plasând credențiale respective pentru accesarea bazei de date)

```
# dump sql database
0 1 * * * mysqldump -u <username> -p<password> drupal_db | gzip > /var/backups/mysql/drupal_db_$(date +\%Y\%m\%d).sql.gz
# backup site
0 2 * * 1 tar czf /var/backups/site/drupal_$(date +\%Y\%m\%d).tar.gz /home/www/drupal
0 3 * * * find /var/backups/mysql -type f -mtime +30 -exec rm {} \;
0 4 * * * find /var/backups/site -type f -mtime +30 -exec rm {} \;
```

### Rotirea jurnalelor

Verificați dacă utilitarul logrotate este instalat în sistem prin comanda

```shell
logrotate -v
```

Dacă programul nu este găsit, instalați-l din repozitoriu.

```shell
apt update && apt install logrotate
```

Accesați folderul `/etc/logrotate.d` și creați fișierul `httpdlog.conf` cu următorul conținut:

```
/var/log/apache2/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 640 root root
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

Înregistrați rotația jurnalelor în cron. Pentru aceasta, creați fișierul `logrotate` în folderul `/etc/cron.daily` cu următorul conținut:

```shell
#!/bin/sh

/usr/sbin/logrotate /etc/logrotate.conf
```

Executați comanda:

```shell
sudo chmod +x /etc/cron.daily/logrotate
```

## Pornirea și testarea

Reporniți Apache HTTP Server. Reporniți cron.

Verificați dacă utilizatorul creat `webadmin` poate lucra în mod remote pe server, prin ssh.

Verificați conținutul directorului `/var/log/apache2/`. Ce conțineacest folder?

## Raport

Prezentați raportul despre lucrul efectuat.

Răspundeți la următoarele întrebări:

1. Care este adresa IP afișată de comanda `ip address`?
2. De ce este necesar să se creeze un utilizator de sistem pentru fiecare site web?
3. În ce cazuri serverul web trebuie să aibă acces complet la directoarele (directorul) site-ului?
4. Ce înseamnă comanda `chmod -R 0755 /home/www/anydir`?
5. Ce face comanda `sudo chmod +x /etc/cron.daily/logrotate`?