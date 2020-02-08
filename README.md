# db-dump-restore

> scripts for dumping and restoring data from databases

## Postgres

### Dump

#### Local

```sh
export POSTGRES_PASSWORD=""
export POSTGRES_USER="postgres"
export POSTGRES_HOST="localhost"
export POSTGRES_PORT="5432"

PGPASSWORD="$POSTGRES_PASSWORD" pg_dumpall --no-role-passwords -h "$POSTGRES_HOST" -p "$POSTGRES_PASSWORD" -U "$POSTGRES_USER" > dump.sql
```

#### Kubernetes

```sh
export POSTGRES_PASSWORD=""
export KUBERNETES_POD=""
export POSTGRES_USER="postgres"
export POSTGRES_PORT="5432"

kubectl exec $KUBERNETES_POD -- sh -c "PGPASSWORD='$POSTGRES_PASSWORD' pg_dumpall --no-role-passwords -p '$POSTGRES_PORT' -U '$POSTGRES_USER'" > dump.sql
```

### Restore

#### Local

#### Kubernetes
