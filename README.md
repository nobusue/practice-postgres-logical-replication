# Simple test case for cascading logical replication of PostgreSQL 

## Replication Configuration
pg_cascade_replication_publisher_1 (publisher)
-> pg_cascade_replication_subscriber_1 (publisher&subscriber)
-> pg_cascade_replication_cascade-subscriber_1 (subscriber)

## Test procedure
After `docker-compose up` , insert new records to publisher.
You can see both subcriber and cascade-subscriber have added records.

### boot all containers
```
$ docker-compose up
```

### publisher
```
$ docker exec -it pg_cascade_replication_publisher_1 /bin/bash
bash-5.0# psql -h localhost -U postgres

postgres=# \c repdb_1

repdb_1=# select * from table_1;
 time | value
------+-------
(0 rows)

repdb_1=# INSERT INTO table_1 VALUES (now(), md5(now()::text));

repdb_1=# select * from table_1;
            time            |              value
----------------------------+----------------------------------
 2022-08-06 13:04:00.203149 | 54bb7a7b271680a9f1fcb4058d24291b
```

### cascade-subscriber
```
$ docker exec -it pg_cascade_replication_cascade-subscriber_1 /bin/bash
bash-5.0# psql -h localhost -U postgres

postgres=# \c repdb_1


repdb_1=# select * from table_1;
            time            |              value
----------------------------+----------------------------------
 2022-08-06 13:04:00.203149 | 54bb7a7b271680a9f1fcb4058d24291b
 ```
