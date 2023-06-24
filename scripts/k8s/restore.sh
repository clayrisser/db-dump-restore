#!/bin/sh

main() {
    _prepare
    _restore_namespace $@
}

_prepare() {
    export NAMESPACE=${_NAMESPACE:-$(kubectl config view --minify --output 'jsonpath={..namespace}')}
    export BACKUP_DIR="$_BACKUP"
    if [ "$BACKUP_DIR" = "" ] || [ ! -d "$BACKUP_DIR" ]; then
        echo "backup directory required" >&2
        exit 1
    fi
}

_restore_namespace() {
    if kubectl get secret postgres-postgres-secret -n "$NAMESPACE" >/dev/null 2>/dev/null; then
        echo "restoring namespace $NAMESPACE"
        sh ./scripts/k8s/restore/postgres.sh $@
        echo "restore completed for namespace $NAMESPACE"
    else
        echo "no restore scripts for namespace $NAMESPACE" >&2
        exit 1
    fi
}

while test $# -gt 0; do
    case "$1" in
        -h|--help)
            echo "data backup k8s - backup k8s data"
            echo " "
            echo "data backup k8s [options]"
            echo " "
            echo "options:"
            echo "    -h, --help         show brief help"
            echo "    -n, --namespace    namespace to restore"
            echo "    -b, --backup       backup directory to restore"
            exit 0
        ;;
        -n|--namespace)
            shift
            export _NAMESPACE=$1
            shift
        ;;
        -b|--backup)
            shift
            export _BACKUP=$1
            shift
        ;;
        -*)
            echo "invalid option $1" 1>&2
            exit 1
        ;;
        *)
            break
        ;;
    esac
done

main $@
