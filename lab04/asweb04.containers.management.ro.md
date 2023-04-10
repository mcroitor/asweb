# Lucrare de laborator No4.: Întreținerea serverului

Scopul acestei lucrări este de a învăța cum să întrețineți serverele web care rulează în containere.

> În producție, crearea de copii de rezervă este adesea realizată cu instrumente specializate, dar în această lucrare se examinează lucrul cu managerul de sarcini __cron__.

> Pentru a facilita colectarea jurnalelor, este o practică standard să se redirecționeze jurnalele în fluxurile standard __STDOUT__ și __STDERR__.

## Pregătirea

Lucrarea se realizează pe baza rezultatului din L.L. nr.3.

Verificați dacă aveți instalat și pornit _Docker Desktop_.

Creați un folder `asweb04`. Toată lucrarea va fi efectuată în acest folder.

Copiați conținutul directorului `asweb03` în directorul `asweb04`.

Lucrarea de laborator se efectuează cu conectarea la rețeaua Internet, deoarece imaginile sunt descărcate din depozitul https://hub.docker.com.

## Executarea

Pentru a face backup vom folosi containerul _cron_, care:

1. face backup la baza de date CMS la fiecare 24 de ore;
2. face backup la directoriul CMS în fiecare luni;
3. șterge backup-urile făcute acum 30 de zile, la fiecare 24 de ore;
4. scrie un mesaj în jurnalul de activități la fiecare minut, `alive, \<username\>`.

Pentru aceasta, creați un folder `cron` în directorul `./files/`. În directorul `./files/cron/` creați directorul `scripts`. În directorul rădăcină creați directorul `backups`, și în interiorul lui `mysql` și `site`.

### mesajul de stare a containerului

În directorul `./files/cron/scripts/` creați fișierul `01_alive.sh` cu următorul conținut:

```shell
#!/bin/sh

echo "alive ${USERNAME}" > /proc/1/fd/1
```

Acest script afișează mesajul `alive ${USERNAME}`.

### Crearea copiei de rezervă a site-ului

În directorul `./files/cron/scripts/` creați fișierul `02_backupsite.sh` cu următorul conținut:

```shell
#!/bin/sh

echo "[backup] create site backup" \
    > /proc/1/fd/1 \
    2> /proc/1/fd/2
tar czfv /var/backups/site/www_$(date +\%Y\%m\%d).tar.gz /var/www/html
echo "[backup] site backup done" \
    >/proc/1/fd/1 \
    2> /proc/1/fd/2
```

Acest script realizează arhivarea directorului `/var/www/html` și salvează arhiva în `/var/backups/site/`.

### crearea copiei de rezervă a bazei de date

În directorul `./files/cron/scripts/` creați fișierul `03_mysqldump.sh` cu următorul conținut:

```shell
#!/bin/sh

echo "[backup] create mysql dump of ${MARIADB_DATABASE} database" \
    > /proc/1/fd/1
mysqldump -u ${MARIADB_USER} --password=${MARIADB_PASSWORD} -v -h mariadb ${MARIADB_DATABASE} \
    | gzip -c > /var/backups/mysql/${MARIADB_DATABASE}_$(date +\%F_\%T).sql.gz 2> /proc/1/fd/1
echo "[backup] sql dump created" \
    > /proc/1/fd/1
```

### ștergerea arhivelor învechite

În directorul `./files/cron/scripts/` creați fișierul `04_clean.sh` cu următorul conținut:

```shell
#!/bin/sh

echo "[backup] remove old backups" \
    > /proc/1/fd/1 \
    2> /proc/1/fd/2
find /var/backups/mysql -type f -mtime +30 -delete \
    > /proc/1/fd/1 \
    2> /proc/1/fd/2
find /var/backups/site -type f -mtime +30 -delete \
    > /proc/1/fd/1 \
    2> /proc/1/fd/2
echo "[backup] done" \
    > /proc/1/fd/1 \
    2> /proc/1/fd/2
```

### pregătirea cron

În directorul `./files/cron/scripts/` creați fișierul `environment.sh` cu următorul conținut:

```shell
#!/bin/sh

env >> /etc/environment

# execute CMD
echo "Start cron" >/proc/1/fd/1 2>/proc/1/fd/2
echo "$@"
exec "$@"
```

În directorul `./files/cron/` creați fișierul `crontab` cu următorul conținut:

```
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
  *  *  *  *  * /scripts/01_alive.sh > /dev/null
  *  *  *  *  * /scripts/02_backupsite.sh > /dev/null
  *  *  *  *  * /scripts/03_mysqldump.sh > /dev/null
  *  *  *  *  * /scripts/04_clean.sh > /dev/null
# Don't remove the empty line at the end of this file. It is required to run the cron job
```

### crearea containerului cron

În rădăcina proiectului creați fișier `Dockerfile.cron` cu următorul conținut:

```dockerfile
FROM debian:latest

RUN apt update && apt -y upgrade && apt install -y cron mariadb-client

COPY ./files/cron/crontab /etc/cron.d/crontab
COPY ./files/cron/scripts/ /scripts/

RUN crontab /etc/cron.d/crontab

ENTRYPOINT [ "/scripts/environment.sh" ]
CMD [ "cron", "-f" ]
```

Redactați fișierul `docker-compose.yml`, adăugând după definiția serviciului `mariadb` următoarele linii:

```yaml
  cron:
    build:
      context: ./
      dockerfile: Dockerfile.cron
    environment:
      USERNAME: <nume prenume>
      MARIADB_DATABASE: sample
      MARIADB_USER: sampleuser
      MARIADB_PASSWORD: samplepassword
    volumes:
      - "./backups/:/var/backups/"
      - "./site/wordpress/:/var/www/html/"
    networks:
      - internal
```

Înlocuiți `<nume prenume>` cu numele și prenumele vostru.

### Rotirea jurnalelor

Atrageți atenția că construirea unui server bazat pe containere afișează jurnalele nu în fișiere, ci în fluxul standard de ieșire.

Verificați, analizând `./files/httpd/httpd.conf` unde se afișează jurnalul Apache HTTP Server pentru scopuri generale? Și jurnalul erorilor?

## Pornirea și testarea

Pentru a construi proiectul, deschideți linia de comandă și executați comanda următoare în rădăcina proiectului:

```shell
docker-compose build
```

Porniți soluția cu comanda:

```shell
docker-compose up -d
```

Citiți jurnalele fiecărui container. Pentru aceasta, executați comanda:

```shell
docker logs <container name>
```

De exemplu, jurnalele containerului creat _cron_ pot fi citite cu următoarea comandă:

```shell
docker logs asweb04-cron-1
```

Așteptați 2-3 minute și verificați ce se află în directoarele `./backups/mysql/` și `./backups/site/`.

Opriți containerele și editați fișierul `./files/cron/crontab` astfel încât:

1. să se creeze o copie de rezervă a bazei de date CMS în fiecare zi la ora 1:00;
2. să se creeze o copie de rezervă a directorului CMS în fiecare luni;
3. să se șteargă copiile de rezervă create cu 30 de zile în urmă în fiecare zi la ora 2:00.

## Raport

Prezentați raportul despre lucrul efectuat.

Răspundeți la întrebări:

1. De ce este necesar să se creeze un utilizator de sistem pentru fiecare site web?
2. În ce cazuri serverul Web trebuie să aibă acces complet la directoarele (directorul) site-ului?
3. Ce înseamnă comanda `chmod -R 0755 /home/www/anydir`?
4. În scripturile shell, fiecare comandă se termină cu linia `> /proc/1/fd/1`. Ce înseamnă asta?