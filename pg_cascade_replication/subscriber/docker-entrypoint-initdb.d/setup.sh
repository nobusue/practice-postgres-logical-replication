#!/bin/bash
set -e

cat >> $PGDATA/pg_hba.conf << EOF
host replication all 0.0.0.0/0 trust
EOF

cat >> ${PGDATA}/postgresql.conf <<EOF
wal_level = logical
EOF

pg_ctl reload
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE DATABASE repdb_1;
  \c repdb_1;

  CREATE TABLE table_1 (time timestamp, value varchar);
  CREATE SUBSCRIPTION my_subscription CONNECTION 'host=publisher port=5432 dbname=repdb_1 user=postgres password=postgres' PUBLICATION my_publication;
  CREATE PUBLICATION cascade_publication FOR ALL TABLES;
EOSQL
