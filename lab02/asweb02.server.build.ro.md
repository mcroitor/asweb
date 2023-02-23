# Lucrare de laborator No1. Construire serverului Web (WAMP)

Scopul lucrării este studierea structurii / principii de lucru a serverului Web Apache. Această lucrare se efectuează sub SO Windows, cu aplicații împachetate în arhive (__nu utilizați instalatoare!__).

## Pregătirea

Descărcați ultimile versiunile aplicațiilor:

1. [__Apache HTTP Server__](https://httpd.apache.org) pentru SO Windows. Fiți atent, pagina oficială a aplicației nu oferă referințe directe pentru descărcarea pachetelor pentru SO Windows, dar totuși el poate fi descărcat urmând primele 2 referințe din lista (_ApacheHaus_ sau _ApacheLounge_).
2. [__MariaDB Server__](https://mariadb.org/) pentru SO Windows - fișier __ZIP__.
3. [__interpretatorul limbajului PHP__](https://php.net) pentru SO Windows, cu extensia pentru Apache HTTP Server. Accesând pagina de descărcare a interpretatorului atrageți atenția la coloana stângă a paginii - ea va ajuta la selectarea pachetului necesar pentru descărcare.

## Executarea

Pe disc __С:__ (sau pe disc __D:__) creați o mapă `server`, în cadrul căruia creați mape `www`, `tmp`, `usr`, `log`.

Despachetați arhivele În mapă `usr`. Stăruițivă să plăsați ficare program în mapa lui sepărată, de exemplu, __Apache HTTP Server__ în mapă `httpd`, __MariaDb Server__ în mapă `mariadb`, __PHP__ în mapă `php`.

În fișier de configurare a serverului Web (`httpd.conf`) activați modul de interacțiune cu PHP. Acest modul se distribuie cu interpretator php (pentru php 7.x el se numește `php7apache2_4.dll`). Configurați mapăl sit-ului. Pentru aceasta setați parametrii `DocumentRoot` și `Directory` din httpd.conf egali cu `c:\server\www`.

În fișier de configurare a interpretatorului limbajului php (`php.ini`) activați suportul mysql (`php_mysqli`, `php_pdo_mysql`). Setați crearea fișierilor temporare de către php în mapă `c:\server\tmp` (parametru `sys_temp_dir`).

Redirecționați crearea jurnalelor de evenimente (apache, mysql, php) în mapă `c:\server\log`.

Creați în directoriu `c:\server\www` fișier `index.php` cu următorul conținut:

```php
<?php phpinfo();
```

## Pornirea și testarea

Porniți serverul bazelor de date _MariaDb_. Pentru aceasta locați în mapă `c:\server\usr\mariadb\bin` fișier `mysqld.exe` și porniți. [Instalarea MariaDB](https://mariadb.com/kb/en/installing-mariadb-windows-zip-packages/) detailată.

Porniți _Apache HTTP Server_. Pentru aceasta locați în mapă `c:\server\usr\httpd\bin` fișier `httpd.exe` și porniți. 

Deschideți în browser URL `http://localhost`.

## Raport

Prezentați raportul despre lucrul efectuat.

Răspundeți la următoarele întrebări:

1. Când se deschide referința `http://localhost`, în browser se afișează informația despre environment al interpretatorului PHP. Care sistem de operare indică PHP?
2. În grup _Apache Environment_ (pe aceiași pagina) localizați variabilă `HTTP_ACCEPT`. Care este valoarea acestei variabile?
3. Care este limita memoriei operative pentru executarea script-ului PHP (variabila `memory_limit` din grup _Core_)?
4. Pentru SO Windows există multe soluții finale Apache. Numiți aceste soluții și specificați particularitățile lor.
