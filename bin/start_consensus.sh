#!/bin/bash
if [[ $(uname) == 'Darwin' ]]; then
    ROOT_PATH=$(dirname "$(realpath "$0")")/..
else
    ROOT_PATH=$(dirname "$(readlink -f "$0")")/..
fi

node_index=$1
grpc_port=$2
service_name=consensus

#register consensus service
SERVICE_PORT=$grpc_port \
NODE_NAME=node$node_index \
SERVICE_NAME=$service_name \
consul-template -template "$ROOT_PATH/template/service.tpl:${service_name}_service.json" \
 -consul-addr 127.0.0.1:8500 \
 -once

curl \
  --request PUT \
  --data @${service_name}_service.json \
  http://127.0.0.1:8500/v1/agent/service/register

# set kv configuration
consul kv put "node$node_index/global.consensus.block_delay_number" 6

#start consensus service
SERVICE_PORT=$grpc_port \
NODE_NAME=node$node_index \
SERVICE_NAME=$service_name \
consul-template -template "$ROOT_PATH/template/log4rs.tpl:${service_name}-log4rs.yaml" \
  -template "$ROOT_PATH/template/${service_name}-config.tpl:${service_name}-config.toml" \
  -consul-addr 127.0.0.1:8500 \
  -exec "$ROOT_PATH/bin/cita_ng_pos run -p $grpc_port"
