#!/bin/sh

DEFAULT_ENVIRONMENT="k8s"

export _TMP_PATH="${XDG_RUNTIME_DIR:-$([ -d "/run/user/$(id -u $USER)" ] && echo "/run/user/$(id -u $USER)" || echo ${TMP:-${TEMP:-/tmp}})}/cody/wizard/$$"
export _STATE_PATH="${XDG_STATE_HOME:-$HOME/.local/state}/dotstow"

main() {
    if [ "$_COMMAND" = "backup" ]; then
        _backup $@
    elif [ "$_COMMAND" = "restore" ]; then
        _restore $@
    fi
}

_backup() {
    exec sh "./scripts/$_ENVIRONMENT/backup.sh" $@
}

_restore() {
    exec sh "./scripts/$_ENVIRONMENT/restore.sh" $@
}

if ! test $# -gt 0; then
    set -- "-h"
fi

while test $# -gt 0; do
    case "$1" in
        -h|--help)
            echo "data - backup and restore data"
            echo " "
            echo "data [options] command <ENVIRONMENT>"
            echo " "
            echo "options:"
            echo "    -h, --help      show brief help"
            echo " "
            echo "commands:"
            echo "    b, backup       backup data"
            echo "    r, restore      restore data"
            exit 0
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

case "$1" in
    b|backup)
        shift
        export _COMMAND=backup
        case $1 in
        -*)
            export _ENVIRONMENT="$DEFAULT_ENVIRONMENT"
            ;;
        *)
            if test $# -gt 0; then
                export _ENVIRONMENT=$1
                shift
            else
                export _ENVIRONMENT="$DEFAULT_ENVIRONMENT"
            fi
        esac
    ;;
    r|restore)
        shift
        export _COMMAND=restore
        case $1 in
        -*)
            export _ENVIRONMENT="$DEFAULT_ENVIRONMENT"
            ;;
        *)
            if test $# -gt 0; then
                export _ENVIRONMENT=$1
                shift
            else
                export _ENVIRONMENT="$DEFAULT_ENVIRONMENT"
            fi
        esac
    ;;
    *)
        echo "invalid command $1" 1>&2
        exit 1
    ;;
esac

main $@
