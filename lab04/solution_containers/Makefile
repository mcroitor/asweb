CACHE=--no-cache

.PHONY: all

all: down remove build up

build:
	docker-compose build $(CACHE)

up:
	docker-compose up -d

down:
	docker-compose down

remove:
	docker-compose rm
