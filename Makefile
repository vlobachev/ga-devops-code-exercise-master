
CONTAINER-PYTHON="ga-devops-code-exercise-master/project"

.PHONY: deps
deps:
	pipenv sync --dev --python 3.7

.PHONY: run_write_db
run_write_db: docker-build-image
	docker-compose run runner make -C /src self_run_write_db
self_run_write_db:
	pipenv run python3 src/write_db.py


.PHONY: verify_data_db
verify_data_db: docker-build-image
	docker-compose run runner make -C /src  self_verify_data_db
self_verify_data_db:
	pipenv run python3 src/verify_data_devops.py


.PHONY: docker-build-image
docker-build-image:
	@echo "Build docker container..."
	@docker build -t ${CONTAINER-PYTHON} .
	@echo "Build docker container DONE"

docker-ssh: docker-build-image
	docker run --rm -it -v "${CURDIR}":/src ${CONTAINER-PYTHON} bash

docker-push: docker-build-image
	$(if $(strip ${DOCKER_ACCOUNT}),, $(error no DOCKER_ACCOUNT variable provided))
	docker tag nrz/lambda docker.pkg.github.com/${DOCKER_ACCOUNT}/${CONTAINER-PYTHON}:latest


docker-build-deps: docker-build-image
	@echo "Runing docker container..."
	docker run --rm -v "${CURDIR}":/src ${CONTAINER-PYTHON} make -C /src build-deps
	@echo "Docker container stoped and removed."


# buld python lib packages
build-deps:
	@echo "Deleting old lambda-layer packages"
#	rm -rf lambdas/lib/python/lib/python3.7/site-packages/ && mkdir lambdas/lib/python/lib/python3.7/site-packages/
	@echo "Installing lambda-layer packages"
	pipenv sync --dev --python 3.7
	@echo "lambda-layer-zip BUILD PACKAGES DONE"
