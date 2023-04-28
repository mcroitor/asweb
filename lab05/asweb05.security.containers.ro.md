# Lucrare de laborator nr. 5: Elemente de securitate a serverilor Web

La utilizarea unui site bazat pe un cluster de containere, o mare parte din responsabilitatea pentru securitate cade pe umerii administratorului cloud-ului. Cu toate acestea, mai multe etape necesare pentru a asigura securitatea (stabilitatea) trebuie efectuate de dezvoltator (DevOps).

## Pregătire

Lucrarea se bazează pe rezultatul L.R. Nr. 4.

Verificați dacă aveți instalat și pornit Docker Desktop.

Creați un folder `asweb05`. În el va fi realizată întreaga lucrare.

Copiați conținutul folderului `asweb04` în folderul `asweb05`.

Laboratorul se efectuează cu conectarea la Internet, deoarece imaginile sunt descărcate din repository-ul https://hub.docker.com.

## Executare și testare

### Căutarea vulnerabilităților

Realizați o construcție:

```shell
docker-compose build
```

Deschideți `Docker Desktop`, mergeți la fila `Images`. Căutați cuvântul `asweb05` - în listă vor fi 4 imagini. Verificați fiecare imagine: la apăsarea pe ea, începe scanarea pentru vulnerabilități.

_În ce imagini au fost găsite vulnerabilități?_

În fișierul `Dockerfile.php-fpm`, schimbați primul rând cu următorul:

```dockerfile
FROM php:8.1-fpm
```

Recreați imaginile și verificați din nou containerul `php-fpm` pentru vulnerabilități.

### Limitarea resurselor containerului

În fișierul `docker-compose.yml`, în descrierea serviciului `httpd`, sub cheia `build`, adăugați următoarea cheie:

```yaml
    deploy:
      resources:
        limits:
          cpus: "0.50"
          memory: 256M
        reservations:
          cpus: "0.25"
          memory: 128M
```

Astfel, limităm consumul de CPU și memorie al serviciului httpd. Specificați astfel de restricții pentru toate containerele.

### Stabilirea condițiilor de stabilitate

Pentru a asigura stabilitatea (restart policy), soluțiile de obicei specifică reguli de reîncărcare a containerului.

Adăugați cheia următoare la definiția deploy a serviciului `httpd`:

```yaml
    deploy:
      ...
      restart_policy:
        condition: on-failure
        delay: 3s
        max_attempts: 5
        window: 60s
```

Adăugați definiții similare pentru toate serviciile.

### Reducerea dimensiunii imaginii

Pentru a reduce dimensiunea imaginilor se folosesc diferite practici. În această lucrare vom șterge urmele lăsate de actualizarea pachetelor.

În fișierul `Dockerfile.httpd` actualizați a doua linie astfel:

```dockerfile
RUN apt update && apt upgrade -y \
	&& rm -rf /var/lib/apt/lists/*
```

Comanda adăugată șterge listele descărcate din repozitouri. Adăugați această comandă la toate descrierile imaginilor după comanda de actualizare a sistemului.

În fișierul `Dockerfile.cron` actualizați a doua linie astfel:

```dockerfile
RUN apt update && apt -y upgrade \
	&& apt install -y cron mariadb-client --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*
```

Opțiunea `--no-install-recommends` interzice comenzii `apt install` să instaleze pachetele recomandate. Adăugați această opțiune în toate descrierile imaginilor în care apare instalarea de pachete.

## Pornirea și testarea

Reconstruiți și porniți proiectul din nou. Verificați cum s-au schimbat dimensiunile imaginilor.

## Răspundeți la întrebări:

1. Există restricții pentru politica de repornire (restart policy)?
2. Ce alte metode există pentru minimizarea dimensiunilor imaginilor?