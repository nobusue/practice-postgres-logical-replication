#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE DATABASE repdb_1;
  \c repdb_1;

  CREATE TABLE table_1 (time timestamp, value varchar);
  -- CREATE SUBSCRIPTION my_subscription CONNECTION 'host=publisher port=5432 dbname=repdb_1 user=postgres password=postgres' PUBLICATION my_publication;
EOSQL
