#!/bin/bash
if [[ $(uname) == 'Darwin' ]]; then
    ROOT_PATH=$(dirname "$(realpath "$0")")/..
else
    ROOT_PATH=$(dirname "$(readlink -f "$0")")/..
fi

node_index=$1
network_grpc_port=$2

#register network service
SERVICE_PORT=$network_grpc_port \
NODE_NAME=node$node_index \
SERVICE_NAME=network \
consul-template -template "$ROOT_PATH/template/network_service.tpl:network_service.json" \
 -consul-addr 127.0.0.1:8500 \
 -once

curl \
  --request PUT \
  --data @network_service.json \
  http://127.0.0.1:8500/v1/agent/service/register

#start network service
SERVICE_PORT=$network_grpc_port \
NODE_NAME=node$node_index \
SERVICE_NAME=network \
consul-template -template "$ROOT_PATH/template/log4rs.tpl:network-log4rs.yaml" \
  -consul-addr 127.0.0.1:8500 \
  -exec "$ROOT_PATH/bin/fake_network.sh $network_grpc_port"
