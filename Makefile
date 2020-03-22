#!make
default: up

ENVFILE = ${CURDIR}/.env

ifneq ("$(wildcard $(ENVFILE))","")
    include .env
    export
endif

VERSION ?= $(shell git describe --tags --always)

.PHONY: deps run_write_db verify_data_db
deps:
	pipenv sync --dev --python 3.7

run_write_db: docker-build-image
	docker-compose run runner make -C /src self_run_write_db
self_run_write_db:
	pipenv run python3 src/write_db.py

## help	:	Print commands help.0
0help : Makefile
	@sed -n 's/^##//p' $<

verify_data_db: docker-build-image
	docker-compose run runner make -C /src  self_verify_data_db
self_verify_data_db:
	pipenv run python3 src/verify_data_devops.py

up: network-create
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose up -d --remove-orphans

## down	:	Stop containers.
down: stop

## start	:	Start containers without updating.
.PHONY: start
start:
	@echo "Starting containers for $(PROJECT_NAME) from where you left off..."
	@docker-compose start

## stop	:	Stop containers.
.PHONY: stop
stop:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose stop

docker-build-image:
	@echo "Build docker container..."
	@docker build -t ${CONTAINER-PYTHON} .
	@echo "Build docker container DONE"

docker-ssh: docker-build-image
	docker run --rm -it -v "${CURDIR}":/src ${CONTAINER-PYTHON} bash

docker-push: docker-build-image docker-login
	docker tag ${CONTAINER-PYTHON} docker.pkg.github.com/${DOCKER_ACCOUNT}/${CONTAINER-PYTHON}:latest
	docker tag ${CONTAINER-PYTHON} docker.pkg.github.com/${DOCKER_ACCOUNT}/${CONTAINER-PYTHON}:${VERSION}
	docker push docker.pkg.github.com/${DOCKER_ACCOUNT}/${CONTAINER-PYTHON}:${VERSION}
	docker push docker.pkg.github.com/${DOCKER_ACCOUNT}/${CONTAINER-PYTHON}:latest

docker-login:
	docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}

docker-build-deps: docker-build-image
	@echo "Runing docker container..."
	docker run --rm -v "${CURDIR}":/src ${CONTAINER-PYTHON} make -C /src deps
	@echo "Docker container stoped and removed."

network-create:
	docker network create web

test: network-create docker-build-image
	docker-compose up -d
	docker-compose exec runner make -C /src self_run_write_db
	docker-compose exec runner make -C /src self_verify_data_db
	docker-compose down
