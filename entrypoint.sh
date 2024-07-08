#!/usr/bin/env bash
set -e

function start_redis {
    su -c "/usr/bin/redis-server /etc/redis/redis.conf" $USER
}

function usage {
    echo "usage: entrypoint.sh [--server|--help]"
}

if [ "$1" != "" ]; then
    case $1 in
        -s | --server )   start_redis
                          exit
                          ;;
        -h | --help )     usage
                          exit
                          ;;
    esac
    shift
fi

exec "$@"
