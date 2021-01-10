# PostgreSQL 論理レプリケーションおためし

## 使い方

docker-compose up して subscriber 側につなげてサブスクライブ設定したらレプリケーションはじまる。

```
$ docker-compose up
```

```
$ docker exec -it pg_logical_replication_subscriber_1 /bin/bash
bash-5.0# psql -h localhost -U postgres

postgres=# \c repdb_1

repdb_1=# select * from table_1;
 time | value
------+-------
(0 rows)

repdb_1=# CREATE SUBSCRIPTION my_subscription CONNECTION 'host=publisher port=5432 dbname=repdb_1 user=postgres password=postgres' PUBLICATION my_publication;

repdb_1=# select * from table_1;
            time            |              value
----------------------------+----------------------------------
 2021-01-10 14:41:34.497245 | a240890d8115f8804e946954e78344a9
```
