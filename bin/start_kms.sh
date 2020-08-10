#!/bin/bash
if [[ $(uname) == 'Darwin' ]]; then
    ROOT_PATH=$(dirname "$(realpath "$0")")/..
else
    ROOT_PATH=$(dirname "$(readlink -f "$0")")/..
fi

node_index=$1
grpc_port=$2
service_name=kms

#register kms service
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

echo "please run:"
echo "../bin/kms run -p $grpc_port"

#start fake kms service
SERVICE_PORT=$grpc_port \
NODE_NAME=node$node_index \
SERVICE_NAME=$service_name \
consul-template -template "$ROOT_PATH/template/log4rs.tpl:${service_name}-log4rs.yaml" \
  -consul-addr 127.0.0.1:8500 \
  -exec "sleep infinity"
