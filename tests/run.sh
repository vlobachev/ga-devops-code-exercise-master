#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

cd ../
docker-compose up -d
docker-compose exec runner make -C /src self_run_write_db
docker-compose exec runner make -C /src self_verify_data_db
docker-compose down
