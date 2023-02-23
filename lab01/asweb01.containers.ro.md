# Lucrare de laborator No1. Containerizare

Această lucrare de laborator vă face cunoștință cu bazele de containerizare și pregătește spațiu
de lucru pentru lucrarile de laborator următoare.

## Pregătirea

Descărcați și instalați [Docker Desktop](https://www.docker.com/products/docker-desktop/).

## Executarea

Creați directorul `asweb01`.

Creați în acest director fișierul `Dockerfile` cu urmîtorul conținut:

```dockerfile
FROM debian:latest
COPY ./site/ /var/www/html/
CMD ["sh", "-c", "echo hello from $HOSTNAME"]
```

În director `asweb01` creați directorul `site`. În acest director nou creați fișierul `index.html` cu oricare conținut.

## Pornirea și testarea

Deschideți terminal (linia de comandă) în directorul `asweb01` și executați următoarea comandă:

```bash
docker build -t asweb01 .
```

_Cât timp se crea imaginea?_

Efectuați comandă pentru pornirea containerului:

```bash
docker run --name asweb01 asweb01
```

_Ce a fost afișat în linia de comandă?_

Ștergeți container și porniți din nou, efectuind comenzile următoare:

```bash
docker rm asweb01
docker run -ti --name asweb01 asweb01 bash
```

În fereastra deschisă executați comenzile:

```bash
cd /var/www/html/
ls -l
```

_Ce se afișează pe ecran?_


Închideți fereastra cu comanda `exit`.

## Raport

Prezentați raportul despre lucrul efectuat.