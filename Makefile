BASH ?= bash

.PHONY: setup up up-detached up-seed build down restart logs ps pull seed clean help

MONGO_URI := mongodb://admin:admin123@localhost:27017/todoapp?authSource=admin
TASKS_SEED := seeds/tasks.json

help:
	@echo "Targets disponibles:"
	@echo "  make setup    - Clona o actualiza backend y frontend"
	@echo "  make up       - Levanta la aplicacion con build"
	@echo "  make up-seed  - Levanta la aplicacion en segundo plano e importa tareas"
	@echo "  make build    - Construye las imagenes"
	@echo "  make down     - Baja los contenedores"
	@echo "  make restart  - Baja y vuelve a levantar"
	@echo "  make logs     - Muestra logs"
	@echo "  make ps       - Muestra estado de servicios"
	@echo "  make pull     - Actualiza backend y frontend"
	@echo "  make seed     - Importa tareas de ejemplo en MongoDB"
	@echo "  make clean    - Baja contenedores y borra volumenes"

setup:
	$(BASH) ./setup.sh

up:
	docker compose up --build

up-detached:
	docker compose up -d --build

up-seed: up-detached seed

build:
	docker compose build

down:
	docker compose down

restart: down up

logs:
	docker compose logs -f

ps:
	docker compose ps

pull:
	$(BASH) ./setup.sh

seed:
	docker compose exec -T mongo mongoimport --uri "$(MONGO_URI)" --collection tasks --jsonArray --drop --file /dev/stdin < $(TASKS_SEED)

clean:
	docker compose down -v --remove-orphans
