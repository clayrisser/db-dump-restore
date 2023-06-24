# db-dump-restore

> scripts for dumping and restoring data from databases

## PostgreSQL

### Dump All Databases

#### Local

```sh
export POSTGRES_PASSWORD=""
export POSTGRES_USER="postgres"
export POSTGRES_HOST="localhost"
export POSTGRES_PORT="5432"

PGPASSWORD="$POSTGRES_PASSWORD" pg_dumpall --no-owner --no-acl -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" > dump.sql
```

#### Kubernetes

```sh
export POD_NAME=""
export POSTGRES_PASSWORD=""
export POSTGRES_USER="postgres"
export POSTGRES_PORT="5432"

kubectl exec "$POD_NAME" -- sh -c \
    "PGPASSWORD='$POSTGRES_PASSWORD' pg_dumpall --no-owner --no-acl -p '$POSTGRES_PORT' -U '$POSTGRES_USER'" > dump.sql
```

### Dump Database

#### Local

```sh
export POSTGRES_PASSWORD=""
export POSTGRES_DATABASE=""
export POSTGRES_USER="postgres"
export POSTGRES_HOST="localhost"
export POSTGRES_PORT="5432"

PGPASSWORD="$POSTGRES_PASSWORD" pg_dump -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" "$POSTGRES_DATABASE" > dump.sql
```

#### Kubernetes

```sh
export POD_NAME=""
export POSTGRES_PASSWORD=""
export POSTGRES_DATABASE=""
export POSTGRES_USER="postgres"
export POSTGRES_PORT="5432"

kubectl exec "$POD_NAME" -- sh -c "PGPASSWORD='$POSTGRES_PASSWORD' pg_dump -p '$POSTGRES_PORT' -U '$POSTGRES_USER' $POSTGRES_DATABASE" > dump.sql
```

### Restore All Databases

#### Local

```sh
export POSTGRES_PASSWORD=""
export POSTGRES_USER="postgres"
export POSTGRES_HOST="localhost"
export POSTGRES_PORT="5432"

PGPASSWORD="$POSTGRES_PASSWORD" psql -f dump.sql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER"
```

#### Kubernetes

```sh
export POD_NAME=""
export POSTGRES_PASSWORD=""
export POSTGRES_USER="postgres"
export POSTGRES_PORT="5432"

cat dump.sql | kubectl exec -i "$POD_NAME" -- sh -c "PGPASSWORD='$POSTGRES_PASSWORD' psql -h localhost -p '$POSTGRES_PORT' -U '$POSTGRES_USER'"
```

### Restore Database

#### Kubernetes

```sh
export POD_NAME=""
export POSTGRES_PASSWORD=""
export POSTGRES_DATABASE=""
export POSTGRES_USER="postgres"
export POSTGRES_PORT="5432"

cat dump.sql | kubectl exec -i "$POD_NAME" -- sh -c "PGPASSWORD='$POSTGRES_PASSWORD' psql -h localhost -p '$POSTGRES_PORT' -U '$POSTGRES_USER' -d '$POSTGRES_DATABASE'"
```

## MongoDB

### Dump All Databases

```sh
export MONGODB_PASSWORD=""
export MONGODB_USER="postgres"
export MONGODB_HOST="localhost"
export MONGODB_PORT="27017"

mongodump --uri="mongodb://$MONGODB_USER:$MONGODB_PASSWORD@$MONGODB_HOST:$MONGODB_PORT"
```

### Restore All Databases

```sh
export MONGODB_PASSWORD=""
export MONGODB_USER="postgres"
export MONGODB_HOST="localhost"
export MONGODB_PORT="27017"

mongorestore --uri="mongodb://$MONGODB_USER:$MONGODB_PASSWORD@$MONGODB_HOST:$MONGODB_PORT" dump/
```

## MySQL/MariaDB

### Dump All Databases

#### Local

```sh
export MYSQL_PWD=""
export MYSQL_USER="root"
export MYSQL_HOST="localhost"
export MYSQL_PORT="3306"

mysqldump --all-databases -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" > dump.sql
```

#### Kubernetes

```sh
export MYSQL_PWD=""
export POD_NAME=""
export MYSQL_USER="root"
export MYSQL_PORT="3306"

kubectl exec "$POD_NAME" -- sh -c \
    "mysqldump --all-databases -h localhost -P '$MYSQL_PORT' -u '$MYSQL_USER'" > dump.sql
```

### Dump Database

#### Local

```sh
export MYSQL_PWD=""
export MYSQL_DATABASE=""
export MYSQL_USER="root"
export MYSQL_HOST="localhost"
export MYSQL_PORT="3306"

mysqldump -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" "$MYSQL_DATABASE" > dump.sql
```

#### Kubernetes

```sh
export MYSQL_PWD=""
export POD_NAME=""
export MYSQL_DATABASE=""
export MYSQL_USER="root"
export MYSQL_PORT="3306"

kubectl exec "$POD_NAME" -- sh -c \
    "mysqldump -h localhost -P '$MYSQL_PORT' -u '$MYSQL_USER' '$MYSQL_DATABASE'" > dump.sql
```

### Restore All Databases

#### Local

```sh
export MYSQL_PWD=""
export MYSQL_USER="root"
export MYSQL_HOST="localhost"
export MYSQL_PORT="3306"

mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" < dump.sql
```

#### Kubernetes

```sh
export MYSQL_PWD=""
export POD_NAME=""
export MYSQL_USER="root"
export MYSQL_PORT="3306"

cat dump.sql | kubectl exec -i "$POD_NAME" -- sh -c \
    "mysql -h localhost -P '$MYSQL_PORT' -u '$MYSQL_USER'"
```

### Restore Database

#### Kubernetes

```sh
export MYSQL_PWD=""
export POD_NAME=""
export MYSQL_DATABASE=""
export MYSQL_USER="root"
export MYSQL_PORT="3306"

cat dump.sql | kubectl exec -i "$POD_NAME" -- sh -c \
    "mysql -h localhost -P '$MYSQL_PORT' -u '$MYSQL_USER' '$MYSQL_DATABASE'"
```

## Elasticsearch

### Dump All Databases

```sh
export ELASTICSEARCH_PASSWORD=""
export ELASTICSEARCH_USER=""
export ELASTICSEARCH_HOST="localhost"
export ELASTICSEARCH_PORT="9200"

elasticdump --input="http://$ELASTICSEARCH_USER:$ELASTICSEARCH_PASSWORD@$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT" \
  --output=dump.json --type=data
```

### Restore All Databases

```sh
export ELASTICSEARCH_PASSWORD=""
export ELASTICSEARCH_USER=""
export ELASTICSEARCH_HOST="localhost"
export ELASTICSEARCH_PORT="9200"

elasticdump --output="http://$ELASTICSEARCH_USER:$ELASTICSEARCH_PASSWORD@$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT" \
  --input=dump.json --type=data
```

## CockroachDB

### Dump All Databases

#### Local

```sh
export COCKROACH_CERTS_DIR=""
export COCKROACH_HOST="localhost"
export COCKROACH_PORT="26257"
export COCKROACH_USER="root"

cockroach dump --certs-dir="$COCKROACH_CERTS_DIR" --host="$COCKROACH_HOST:$COCKROACH_PORT" --insecure --user="$COCKROACH_USER" > dump.sql
```

#### Kubernetes

```sh
export COCKROACH_CERTS_DIR=""
export POD_NAME=""
export COCKROACH_USER="root"

kubectl exec "$POD_NAME" -- sh -c \
  "cockroach dump --certs-dir=/cockroach-certs --host=localhost:26257 --insecure --user='$COCKROACH_USER'" > dump.sql
```

### Restore All Databases

#### Local

```sh
export COCKROACH_CERTS_DIR=""
export COCKROACH_HOST="localhost"
export COCKROACH_PORT="26257"
export COCKROACH_USER="root"

cockroach sql --certs-dir="$COCKROACH_CERTS_DIR" --host="$COCKROACH_HOST:$COCKROACH_PORT" --insecure --user="$COCKROACH_USER" < dump.sql
```

#### Kubernetes

```sh
export COCKROACH_CERTS_DIR=""
export POD_NAME=""
export COCKROACH_USER="root"

cat dump.sql | kubectl exec -i "$POD_NAME" -- sh -c \
  "cockroach sql --certs-dir=/cockroach-certs --host=localhost:26257 --insecure --user='$COCKROACH_USER'"
```
