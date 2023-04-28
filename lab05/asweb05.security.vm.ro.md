# Lucrare de laborator nr. 5: Elemente de securitate a serverilor Web

Una din sarcini ale administratorului de server este audit de securitate care se efectuiază periodic. Scopul aceastei lucrări este familiarizarea cu acest proces.

## Pregătire

Porniți serverul virtual creat în LL Nr. 4. Conectați la server virtual prin SSH (putty sau ssh).

## Executare

Verificați securitatea serverului după lista următoare de control. Elemente tăiate din lista omiteți.

1. ~~__Securitate fizică__~~
2. ~~__Criptarea sistemei de fișiere__ – verificați dacă sistem de fișiere criptează datele.~~
3. __Îmbunătățirea sistemei de operare__ – îmbunătățiți sistem de operare și aplicații instalate, dacă este necesitate.
4. __Configurația corectă a accesului din rețea__ – verificați dacă este instalat firewall. Dacă firewall nu este instalat atunci instalați și porniți. Permiteți acces extern numai pentru porturi `22`, `80`, `443`. Se recomandă firewall ufw.
  1. verificarea porturilor deschise poate fi efectuată cu comanda `sudo netstat -plunt`
  2. acces către port `80` se permite prin comanda `sudo ufw allow 80`
5. __Criptarea datelor din trafic__ – verificați, dacă se utilizează pentru sit-uri protocol HTTPS. Dacă HTTPS nu se utilizează, activați suportul HTTPS la Apache HTTP Server și php.
  1. suportul SSL de Apache HTTP Server realizează modul `mod_ssl`
  2. suportul SSL de PHP realizează extensie php_openssl
6. ~~__parolele complexe (se omite)__~~
7. __Limitarea accesului utilizatorilor__ – verificați dacă în SO nu sunt utilizatori necunoscuți sau neutilizați. Blocați acces pentru acești utilizatori.
8. ~~__Izolarea rolurilor și serviciilor__ (se omite)~~
9. __Сopie de rezervă__ – verificați dacă crearea copiilor de rezervă a sit-urilor și bazelor de date se face regular. Dacă nu, atunci creați reguli respective în cron (LL Nr.4).
10. __Politici de securitate a bazelor de date__ – verificați că fiecare baza de date are utilizatorul său personal
11. __politici de securitate a serverului Web__ – ascundeți versiunea aplicațiilor utilizate (dezactivați banere la Apache Web Server și PHP). Dezactivați funcții PHP potențial vulnerabile.
12. __Jurnalizarea și monitorizarea__ – pentru securizarea serverului de la atacuri de forța brută (brutforce) instalați aplicația `fail2ban`.

## Răspundeți la întrebări:

1. Care funcții PHP sunt potențial vulnerabile?
2. În ce cazuri (dacă sunt așa cazuri în general) poate fi pus acces 0777 către director?
3. Pentru monitorizarea greșelilor de sistem există diferite aplicații. Aduceți exemplu de așa fel de aplicații.
4. Cum credeți, de ce unele elemente din lista de control sunt omise?
