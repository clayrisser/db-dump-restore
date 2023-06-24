#!/bin/sh

SECRET_RESOURCE="
$(kubectl get secret postgres-postgres-secret -o json -n "$NAMESPACE")
"
DEPLOYMENT_NAME="postgres"
POD_NAME=$(kubectl get pods -l deployment-name=$DEPLOYMENT_NAME -n "$NAMESPACE" -o jsonpath='{.items[0].metadata.name}')

export POSTGRES_PASSWORD="$(echo "$SECRET_RESOURCE" | jq -r '.data.password' | openssl base64 -d)"
export POSTGRES_USER="$(echo "$SECRET_RESOURCE" | jq -r '.data.username' | openssl base64 -d)"
export POSTGRES_PORT="5432"

kubectl exec "$POD_NAME" -- sh -c \
    "PGPASSWORD='$POSTGRES_PASSWORD' pg_dumpall --no-owner --no-acl -p '$POSTGRES_PORT' -U '$POSTGRES_USER'" > "$BACKUP_DIR/dump.sql"
