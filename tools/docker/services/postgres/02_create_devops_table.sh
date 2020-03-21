#!/bin/bash
set -e # exit immediately if a command exits with a non-zero status.

POSTGRES="psql -U postgres"

# create database for superset
echo "Creating devops table"
$POSTGRES <<EOSQL
\connect metabase
CREATE TABLE gameanalytics.devops (
    id INTEGER PRIMARY KEY NOT NULL,
    c0 VARCHAR(8) NULL,
    c1 VARCHAR(8) NULL,
    c2 VARCHAR(8) NULL,
    c3 VARCHAR(8) NULL,
    c4 VARCHAR(8) NULL,
    c5 VARCHAR(8) NULL,
    date TIMESTAMP NOT NULL
);
EOSQL