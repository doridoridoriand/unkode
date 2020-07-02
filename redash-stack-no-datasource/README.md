
# Redash Stack
Redash server and workers

# Dependencies
- Docker minimum 18.03
- docker-compose minimum 1.21.0

# Software Included
- Redash 8.0.2
- Postgres 9.6.18


# Usage
```
$ docker-compose up -d
$ docker exec -it redash-server /bin/bash
$ ./manage.py database create_tables
```
