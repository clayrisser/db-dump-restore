#!/bin/sh

SECRET_RESOURCE="
$(kubectl get secret postgres-postgres-secret -o json -n "$NAMESPACE")
"
DEPLOYMENT_NAME="postgres"
POD_NAME=$(kubectl get pods -l deployment-name=$DEPLOYMENT_NAME -n "$NAMESPACE" -o jsonpath='{.items[0].metadata.name}')

export POSTGRES_PASSWORD="$(echo "$SECRET_RESOURCE" | jq -r '.data.password' | openssl base64 -d)"
export POSTGRES_USER="$(echo "$SECRET_RESOURCE" | jq -r '.data.username' | openssl base64 -d)"
export POSTGRES_PORT="5432"

REPLICAS=$(kubectl get deployment "$DEPLOYMENT_NAME" -o json -n "$NAMESPACE" | jq '.spec.replicas')
kubectl scale --replicas=1 deployment/$DEPLOYMENT_NAME -n "$NAMESPACE"
kubectl rollout status deployment/$DEPLOYMENT_NAME -n "$NAMESPACE"
POD_NAME=$(kubectl get pods -l deployment-name=$DEPLOYMENT_NAME -n "$NAMESPACE" -o jsonpath='{.items[0].metadata.name}')

cat "$BACKUP_DIR/dump.sql" | kubectl exec -i "$POD_NAME" -n "$NAMESPACE" -- sh -c \
    "PGPASSWORD='$POSTGRES_PASSWORD' psql -p '$POSTGRES_PORT' -U '$POSTGRES_USER'"

kubectl scale --replicas=$REPLICAS deployment/$DEPLOYMENT_NAME -n "$NAMESPACE"
kubectl rollout status deployment/$DEPLOYMENT_NAME -n "$NAMESPACE"
