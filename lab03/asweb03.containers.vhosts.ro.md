# Lucrare de laborator № 3: Pornirea unui site în container.

Scopul acestei lucrări este familiarizarea cu pornirea site-urilor în containere. Totodată studentul face cunoștința cu procesul creării a clasterului de containere și procesul instalării  site-urilor în baza Wordpress.

Rezultatul efectuării acestei lucrări va fi obținut un clater compus din 3 containere:

 - __Apache HTTP server__ - container obține interpelări și transmite către container PHP-FPM;
 - __PHP-FPM__ - container cu server PHP-FPM;
 - __MariaDB__ - container cu server bazelor de date.

## Pregătirea

Verificați, dacă aveți instalat și pornit _Docker Desktop_.

Creați mapă `asweb03`. Toate pași ai lucrării se efectuiază din această mapă.

Creați mape: `database` - pentru baza de date, `files` - pentru păstrarea configurațiilor și `site` - în această mapă va fi plăsat site.

Lucrare de laborator se efectuează cu calculator conectat la rețea Internet, fiindcă se discarc imaginile din repozitoriu https://hub.docker.com

## Executarea

Descărcați [CMS Wordpress](https://wordpress.org/) și despachetați în mapă `site`. Ca rezultat în mapa `site` o să aveți mapă `wordpress` cu codul sursă a site-ului.

### Container Apache HTTP Server

Ca primul pas o să creăm fișier de configurație pentru Apache HTTP Server. Pentru aceasta executați următoarele comenzi din linia de comandă:

```shell
# comandă descarcă imaginea httpd și pornește container cu nume httpd în baza imaginii
docker run -d --name httpd  httpd:2.4

# copiem fișier de configurație din container în mașina host, mapa .\files\httpd
docker cp httpd:/usr/local/apache2/conf/httpd.conf .\files\httpd\httpd.conf

# oprim container httpd
docker stop httpd

# ștergem container
docker rm httpd
```

În fișier creat `.\files\httpd\httpd.conf` de-comentați linii care conțin încărcarea extensiilor `mod_proxy.so`, `mod_proxy_http.so`, `mod_proxy_fcgi.so`.

Găsiți în fișier de configurare definiția parametrului `ServerName`. După acest parametru adăugați următoare linii:

```
# definirea nume domen site
ServerName wordpress.localhost:80
# redirecționarea interpelărilor către container php-fpm
ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://php-fpm:9000/var/www/html/$1
# fișier index
DirectoryIndex /index.php index.php
```

Totodată locați definirea parametrului `DocumentRoot` și atribuiți valoarea `/var/www/html`, ca și în următoarea linie.

Creați fișier `Dockerfile.httpd` cu următorul conținut:

```dockerfile
FROM httpd:2.4

RUN apt update && apt upgrade -y

COPY ./files/httpd/httpd.conf /usr/local/apache2/conf/httpd.conf
```

Particularitățile lucrului cu container _httpd_ puteți afla aici: [HTTPD Container](https://hub.docker.com/_/httpd).

### Container PHP-FPM

Creați fișier `Dockerfile.php-fpm` cu următorul conținut:

```dockerfile
FROM php:7.4-fpm

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-configure pdo_mysql \
	&& docker-php-ext-install -j$(nproc) gd mysqli
```

Particularitățile lucrului cu container _php_ puteți afla aici: [PHP Container](https://hub.docker.com/_/php).

### Container MariaDB

Creați fișier `Dockerfile.mariadb` cu următorul conținut:

```dockerfile
FROM mariadb:10.8

RUN apt-get update && apt-get upgrade -y
```

Particularitățile lucrului cu container _mariadb_ puteți afla aici: [MariaDB Container](https://hub.docker.com/_/mariadb).

### Asamblarea soluției

Creați fișier `docker-compose.yml` cu următorul conținut:

```yaml
version: '3.9'

services:
  httpd:
    build:
      context: ./
      dockerfile: Dockerfile.httpd
    networks:
      - internal
    ports:
      - "80:80"
    volumes:
      - "./site/wordpress/:/var/www/html/"
  php-fpm:
    build:
      context: ./
      dockerfile: Dockerfile.php-fpm
    networks:
      - internal
    volumes:
      - "./site/wordpress/:/var/www/html/"
  mariadb:
    build: 
      context: ./
      dockerfile: Dockerfile.mariadb
    networks:
      - internal
    environment:
     MARIADB_DATABASE: sample
     MARIADB_USER: sampleuser
     MARIADB_PASSWORD: samplepassword
     MARIADB_ROOT_PASSWORD: rootpassword
    volumes:
      - "./database/:/var/lib/mysql"
networks:
  internal: {}
```

Acest fișier definește o structură din 3 containere: http ca punct de intrare, container php-fpm și container cu baza de date. Pentru comunicare între containere se definește totodată rețea `internal` cu configurația implicită.

## Pornirea și testarea

În mapa lucrării de laborator deschideți consolă și executați comanda:

```shell
docker-compose build
```

În baza definițiilor create docker va crea imagini pentru servicii noastre. _Cât timp se construiește proiectul?_

Executați comanda:

```shell
docker-compose up -d
```

În baza imaginilor create va fi pornite containere. Deschideți în browser pagina: http://wordpress.localhost și efectuați instalarea site-ului. __Fiți atent, fiindcă containere văd unul pe altul în rețea virtuală internă după nume. Având această în vedere la configurarea conexiunii cu baza de date trebuie să specificați host egal cu nume container, în cazul nostru `mariadb`__. Nume utilizator bazei de date, parola lui și denumirea bazei de date puteți găsi în fișier `docker-compose.yml`.

Efectuați consecutiv următoarele comenzi:

```shell
# oprirea containerelor
docker-compose down
# ștergerea containerelor
docker-compose rm
```

Verificați, dacă se deschide site http://wordpress.localhost . Porniți containere din nou:

```shell
docker-compose up -d
```

și verificați disponibilitatea site-ului.

## Raport

Prezentați raportul despre lucrul efectuat.

Răspundeți la următoarele întrebări:

* Cum se copie un fișier din container în calculator host?
* Ce specifică parametrul `DocumentRoot` în fișier de configurare Apache HTTP Server?
* În fișier `docker-compose.yml` mapă `database` a hostului se montează în mapă `/var/lib/mysql` a containerului `mariadb`. Pentru ce se montează această mapă în container?
