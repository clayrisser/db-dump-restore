#!/bin/sh

export _TMP_PATH="${XDG_RUNTIME_DIR:-$([ -d "/run/user/$(id -u $USER)" ] && echo "/run/user/$(id -u $USER)" || echo ${TMP:-${TEMP:-/tmp}})}/cody/wizard/$$"
export _STATE_PATH="${XDG_STATE_HOME:-$HOME/.local/state}/dotstow"
export _STOWED_PATH="$_STATE_PATH/stowed"

main() {
    _prepare
    if [ "$_ALL" = "1" ]; then
        _backup_all_namespaces $@
    else
        _backup_namespace $@
    fi
}

_prepare() {
    export NAMESPACE=${_NAMESPACE:-$(kubectl config view --minify --output 'jsonpath={..namespace}')}
    export OUTPUT_DIR=$(pwd)/backups/$NAMESPACE/$(date +'%s')_$(date +'%Y-%m-%d_%H-%M-%S')
}

_backup_all_namespaces() {
    for n in $(kubectl get ns | tail -n +2 | cut -d' ' -f1); do
        export _NAMESPACE=$n
        _prepare
        ( _backup_namespace $@ ) || true
    done
}

_backup_namespace() {
    if kubectl get secret postgres-postgres-secret -n "$NAMESPACE" >/dev/null 2>/dev/null; then
        mkdir -p $OUTPUT_DIR
        echo "backing up namespace $NAMESPACE"
        sh ./scripts/k8s/backup/postgres.sh $@
        echo "backup completed for namespace $NAMESPACE"
    else
        echo "no backup scripts for namespace $NAMESPACE" >&2
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
            echo "    -n, --namespace    namespace to backup"
            echo "    -a, --all          backup all namespaces"
            exit 0
        ;;
        -n|--namespace)
            shift
            export _NAMESPACE=$1
            shift
        ;;
        -a|--all)
            shift
            export _ALL="1"
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
