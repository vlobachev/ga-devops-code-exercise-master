#!make
default: up

CONTAINER-PYTHON-FULLNAME = "docker.pkg.github.com/${GITHUB_ACCOUNT}/${CONTAINER-PYTHON}"
ENVFILE = ${CURDIR}/.env

ifneq ("$(wildcard $(ENVFILE))","")
    include .env
    export
endif

VERSION ?= $(shell git describe --tags --always)

.PHONY: deps run_write_db self_run_write_db verify_data_db self_verify_data_db up down start stop docker-build-image docker-ssh docker-push docker-login test

## help:			Print commands help.0
help: Makefile
	@sed -n 's/^##//p' $<

## deps:			Install deps by pipenv
deps:
	pipenv sync --dev --python 3.7

## run_write_db:		Write data to DB over docker-compose
run_write_db:
	docker-compose run runner make -C /src self_run_write_db

## self_run_write_db:	Write data to DB localy or inside the container
self_run_write_db:
	pipenv run python3 src/write_db.py

## verify_data_db:	Verify data in DB over docker-compose
verify_data_db:
	docker-compose run runner make -C /src  self_verify_data_db

## self_verify_data_db:	Verify data to DB localy or inside the container
self_verify_data_db:
	pipenv run python3 src/verify_data_devops.py
## up: 			Starting up all containers for project
up:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose up -d --remove-orphans

## down: 			Stop containers.
down: stop

## start: 		Start containers without updating.
start:
	@echo "Starting containers for $(PROJECT_NAME) from where you left off..."
	@docker-compose start

## stop: 			Stop containers.
stop:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose stop

## docker-build-image:	Build container.
docker-build-image:
	@echo "Build docker container..."
	docker build -t ${CONTAINER-PYTHON-FULLNAME}:latest .
	docker tag ${CONTAINER-PYTHON-FULLNAME}:latest ${CONTAINER-PYTHON-FULLNAME}:${VERSION}
	@echo "Build docker container DONE"

## docker-ssh: 		Build container.
docker-ssh: docker-build-image
	docker run --rm -it -v "${CURDIR}":/src ${CONTAINER-PYTHON-FULLNAME} bash

## docker-push: 		Push container to registry.
docker-push: docker-login
	docker push ${CONTAINER-PYTHON-FULLNAME}:${VERSION}
	docker push ${CONTAINER-PYTHON-FULLNAME}:latest

## docker-push: 		Login to docker registry.
docker-login:
	echo ${GITHUB_TOKEN} | docker login docker.pkg.github.com -u ${GITHUB_ACCOUNT} --password-stdin

## test:			Test our env and scrypts
test: docker-login
	docker-compose up -d
	docker-compose run runner make -C /src self_run_write_db
	docker-compose run runner make -C /src self_verify_data_db
	docker-compose down
