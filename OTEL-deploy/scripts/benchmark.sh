#!/usr/bin/env bash

## This script runs CT (and necessary dependencies) in docker container(s)

set -euo pipefail

# ensure dir
cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

help() {
    echo
    echo "-h|--help:                                 To display this usage info"
    echo "-b|--benchmark conn|subunsub|1t1:          Which Benchmark to run"
    echo "-q|--qos 0|1|2:                            1t1 PubSub Messaging QoS level"
    echo "-t|--tps 1000|2000|4000:                   1t1 PubSub Messaging TPS"
    echo "--down:                                    To stop the benchmark"
}

set +e
if docker compose version; then
    DC='docker compose'
elif command -v docker-compose; then
    DC='docker-compose'
else
    echo 'Neither "docker compose" or "docker-compose" are available, stop.'
    exit 1
fi
set -e

COMPOSE_TYPE="novalue"
QOS="novalue"
TPS="novalue"
DOWN="no"
while [ "$#" -gt 0 ]; do
    case $1 in
        -h|--help)
            help
            exit 0
            ;;
        -b|--benchmark)
            COMPOSE_TYPE="${2%/}"
            echo "COMPOSE_TYPE: $COMPOSE_TYPE"
            shift 2
            ;;
        -q|--qos)
            QOS="${2%/}"
            echo "QOS: $QOS"
            shift 2
            ;;
        -t|--tps)
            TPS="${2%/}"
            echo "TPS: $TPS"
            shift 2
            ;;
        --down)
            DOWN="yes"
            shift 1
            ;;
        *)
            echo "unknown option $1"
            help
            exit 1
            ;;
    esac
done


if [ "${COMPOSE_TYPE}" = 'novalue' ]; then
    echo "must provide --benchmark arg"
    help
    exit 1
fi

case "${COMPOSE_TYPE}" in
    conn)
        COMPOSE_FILE_NAME='docker-compose-benchmark-conn.yaml'
        ;;
    subunsub)
        COMPOSE_FILE_NAME='docker-compose-benchmark-subunsub.yaml'
        ;;
    1t1)
        COMPOSE_FILE_NAME='docker-compose-benchmark-1t1-pubsub.yaml'
        ;;
    *)
        echo "Benchmark must be `conn,` `subunsub,` or `1t1`"
        exit 1
        ;;
esac

if [ "${COMPOSE_TYPE}" == '1t1' ]; then
    if [ "${QOS}" = 'novalue' ]; then
        echo "for 1t1 benchmark, must provide --qos arg"
        help
        exit 1
    else
        case "${QOS}" in
            0|1|2)
                export BENCH_1T1_MSG_QOS=${QOS}
                ;;
            *)
                echo "QoS must be 0, 1, or 2"
                exit 1
                ;;
        esac
    fi
else
    echo "QOS is not applicable for ${COMPOSE_TYPE} benchmark, skipping"
fi


if [ "${COMPOSE_TYPE}" == '1t1' ]; then
   if [ "${TPS}" = 'novalue' ]; then
      echo "for 1t1 benchmark, must provide --tps arg"
      help
      exit 1
   else
       case "${TPS}" in
           20)
               export BENCH_1T1_MSG_CLIENT_COUNT=5
               ;;
           1000)
               export BENCH_1T1_MSG_CLIENT_COUNT=250
               ;;
           2000)
               export BENCH_1T1_MSG_CLIENT_COUNT=500
               ;;
           4000)
               export BENCH_1T1_MSG_CLIENT_COUNT=1000
               ;;
           *)
               echo "TPS only supports 1000, 2000, 4000"
               exit 1
               ;;
       esac
   fi
else
    echo "TPS is not applicable for ${COMPOSE_TYPE} benchmark, skipping"
fi

case "${DOWN}" in
    yes)
        $DC -f $COMPOSE_FILE_NAME down
        exit 0
        ;;
    no)
        $DC -f $COMPOSE_FILE_NAME up -d
esac

exit 0
