
# Redash Stack
Redash server and workers

# Dependencies
- Docker minimum 19.03
- docker-compose minimum 1.24.0

# Software Included
- Redash 8.0.2
- Postgres 10.13


# Usage
```
$ docker-compose up -d
$ docker exec -it redash-server /bin/bash
$ ./manage.py database create_tables
```
