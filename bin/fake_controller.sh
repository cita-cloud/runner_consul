#!/bin/bash

grpc_port=$1

pid=$$
echo "pid: $pid"

echo "start controller:"
echo `date +%Y-%m-%d-%H-%M-%S.%N`
echo "config:"
echo "grpc port $grpc_port"
cat ./controller-log4rs.yaml
cat ./controller-config.toml
sleep infinity
