# Simple test case for cascading logical replication of PostgreSQL 

## Replication Configuration
```
publisher (publisher only)
-> subscriber (subscriber & publisher)
-> cascade-subscriber (subscriber only)
```

## Test procedure
After `docker-compose up` , insert new records to publisher.
You can see both subcriber and cascade-subscriber have added records.

### Boot all containers
```
docker-compose up
```

### publisher
(Execute in another terminal)
```
docker-compose exec publisher bash -c "psql -U postgres postgres"
```
Inside publisher container:
```
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
(Execute in another terminal)
```
docker-compose exec cascade-subscriber bash -c "psql -U postgres postgres"
```
Inside cascade-subscriber container, you can see replicated records:
```
postgres=# \c repdb_1


repdb_1=# select * from table_1;
            time            |              value
----------------------------+----------------------------------
 2022-08-06 13:04:00.203149 | 54bb7a7b271680a9f1fcb4058d24291b
```

### Cleaning up
Close all termials and stop docker-compose using `CTRL-C`.
