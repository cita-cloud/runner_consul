#!/bin/bash

n=$1
echo "node number is $n"

base_port=$[49999+n*1000]
echo "base_port is $base_port"
networ_port=$[base_port+1]
echo "networ_port is $networ_port"
consensus_port=$[base_port+2]
echo "consensus_port is $consensus_port"
executor_port=$[base_port+3]
echo "executor_port is $executor_port"
storage_port=$[base_port+4]
echo "storage_port is $storage_port"
controller_port=$[base_port+5]
echo "controller_port is $controller_port"
kms_port=$[base_port+6]
echo "kms_port is $kms_port"

if [[ $(uname) == 'Darwin' ]]; then
    ROOT_PATH=$(dirname "$(realpath "$0")")/..
else
    ROOT_PATH=$(dirname "$(readlink -f "$0")")/..
fi

#global configuration
echo "set global configuration"
consul kv put "node$n/global.log4rs.level" info
consul kv put "node$n/global.log4rs.appenders" journey-service

echo "start network"
$ROOT_PATH/bin/start_network.sh $n $networ_port
