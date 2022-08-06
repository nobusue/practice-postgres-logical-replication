# Simple test case for CDC from PostgreSQL replica (using logical replication)

## Configuration
```
publisher
-> subscriber
-> CDC by Debezium
```

## Test procedure
After `docker-compose up` , insert new records to publisher.
You can see change events on Kafka via CDC from subscriber.

### Boot all containers
```
docker-compose up
```

### Debezium(Kafka Connect) registration
(Execute in another terminal)
```
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register.json
```

### Watch Kafka topic
(Execute in another terminal)
```
docker-compose exec kafka /kafka/bin/kafka-console-consumer.sh --bootstrap-server kafka:9092 --from-beginning --property print.key=true --topic replica.public.table_1
```

### Add data to publisher DB
(Execute in another terminal)
```
docker-compose exec publisher bash -c "psql -U postgres postgres"
```

For `postgres=# ` prompt, type as below:

```
\c repdb_1
select * from table_1;
INSERT INTO table_1 VALUES (now(), md5(now()::text));
select * from table_1;
```

After that, you can see change events in Kafka consumer terminal.

### Cleaning up
Close all termials and stop docker-compose using `CTRL-C`.
