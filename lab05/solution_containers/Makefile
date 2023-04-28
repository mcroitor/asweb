# CACHE=--no-cache
CACHE=

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

help:
	@echo "make - executes sequentially 'down', 'remove', 'build', 'up' actions"
	@echo "make down - stop containers"
	@echo "make remove - remove containers"
	@echo "make build - build containers"
	@echo "make up - start containers"
