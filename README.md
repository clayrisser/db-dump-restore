# db-dump-restore

> scripts for dumping and restoring data from databases

## Postgres

### Dump All

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
export POSTGRES_PASSWORD=""
export KUBERNETES_POD=""
export POSTGRES_USER="postgres"
export POSTGRES_PORT="5432"

kubectl exec "$KUBERNETES_POD" -- sh -c \
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
export POSTGRES_PASSWORD=""
export KUBERNETES_POD=""
export POSTGRES_DATABASE=""
export POSTGRES_USER="postgres"
export POSTGRES_PORT="5432"

kubectl exec "$KUBERNETES_POD" -- sh -c "PGPASSWORD='$POSTGRES_PASSWORD' pg_dump -p '$POSTGRES_PORT' -U '$POSTGRES_USER' $POSTGRES_DATABASE" > dump.sql
```

### Restore All

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
export POSTGRES_PASSWORD=""
export KUBERNETES_POD=""
export POSTGRES_USER="postgres"
export POSTGRES_PORT="5432"

cat dump.sql | kubectl exec -i "$KUBERNETES_POD" -- sh -c "PGPASSWORD='$POSTGRES_PASSWORD' psql -h '$POSTGRES_HOST' -p '$POSTGRES_PORT' -U '$POSTGRES_USER'"
```

### Restore Database

#### Kubernetes

```sh
export POSTGRES_PASSWORD=""
export KUBERNETES_POD=""
export POSTGRES_DATABASE=""
export POSTGRES_USER="postgres"
export POSTGRES_PORT="5432"

cat dump.sql | kubectl exec -i "$KUBERNETES_POD" -- sh -c "PGPASSWORD='$POSTGRES_PASSWORD' psql -h '$POSTGRES_HOST' -p '$POSTGRES_PORT' -U '$POSTGRES_USER' -d '$POSTGRES_DATABASE'"
```

## MongoDB

### Dump

```sh
export MONGODB_PASSWORD=""
export MONGODB_USER="postgres"
export MONGODB_HOST="localhost"
export MONGODB_PORT="27017"

mongodump --uri="mongodb://$MONGODB_USER:$MONGODB_PASSWORD@$MONGODB_HOST:$MONGODB_PORT"
```
