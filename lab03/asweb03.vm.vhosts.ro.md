# Lucrare de laborator № 3: Configurarea host-urilor virtuale.

Scopul acestei lucrări este studierea procesului de adăugare și configurare a sit-urilor (host-urilor virtuale). În plus student face cunoștința cu metode de instalare a sit-urilor.

## Pregătirea

Porniți mașina virtuală obținută în _lucrare de laborator 1_ șî întrați în ea. 

## Executarea

Instalați LAMP în mașina virtuală. _Ce comenzi a'i utilizat?_

Descărcați [SGBD PhpMyAdmin](http://phpmyadmin.net/). Pentru descărcarea puteți utiliza _curl_, _wget_ sau browser consol _lynx_, _links_.

Descărcați [CMS Drupal](https://www.drupal.org/).

Despachetați fișierele descărcate în mape:
1. SGBD PhpMyAdmin ==> `/home/www/phpmyadmin`;
2. CMS Drupal ==> `/home/www/drupal`.

Creați din linia de comandă pentru CMS baza de date cu denumirea `drupal_db` și utilizator acestei baze cu numele vostru.

În mapa `/etc/apache2/sites-available` creați fișier `01-phpmyadmin` cu conținut:

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

În mapa `/etc/apache2/sites-available` creați fișier `02-drupal` cu conținut:

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

Înregistrați configurații efectuând comenzile:
```bash
sudo a2ensite 01-phpmyadmin
sudo a2ensite 02-drupal
```

## Pornirea și testarea

Reporniți Apache Web Server:

```shell
systemctl reload apache2
```

Verificați în browser accesibilitatea sit-urilor `http://drupal.localhost` și `http://phpmyadmin.localhost`. Instalați ambele sit-uri.
    
## Raport

Prezentați raportul despre lucrul efectuat.

Răspundeți la următoarele întrebări:

1. Cum poate fi descărcat un fișier cu ajutorul aplicației curl?
2. De ce pentru fiecare sit trebuie să fie creat baza de date și utilizatorul bazei de date aparte?
3. Cum puteți modifica portul de acces la SGBD instalat la port `1234`?
