#!/bin/sh

SECRET_RESOURCE="
$(kubectl get secret postgres-postgres-secret -o json -n "$NAMESPACE")
"
SVC_NAME="postgres"
POD_NAME=$(kubectl get service postgres \
    --template='{{range $key, $value := .spec.selector}}{{if $value}}--selector {{$key}}={{$value}} {{end}}{{end}}' | \
    xargs kubectl get pods | sed -n '2p' | cut -d' ' -f1)

export POSTGRES_PASSWORD="$(echo "$SECRET_RESOURCE" | jq -r '.data.password' | openssl base64 -d)"
export POSTGRES_USER="$(echo "$SECRET_RESOURCE" | jq -r '.data.username' | openssl base64 -d)"
export POSTGRES_PORT="5432"

kubectl exec "$POD_NAME" -- sh -c "PGPASSWORD='$POSTGRES_PASSWORD' pg_dumpall -p '$POSTGRES_PORT' -U '$POSTGRES_USER'" > $OUTPUT_DIR/dump.sql
