
# Redash Stack
BI tools and DB stacks for analyze easily.

# Dependencies
- Docker minimum 18.03
- docker-compose minimum 1.21.0

# Software Included
- Clickhouse server 1.1
- Clickhouse client 18.12
- MySQL 5.7.12
- MongoDB 4.0
- Postgres 9.6.9
- Redash 4.0.0

# Usage
```
$ docker-compose up -d
$ docker exec -it redash-server /bin/bash
$ ./manage.py database create_tables
```
