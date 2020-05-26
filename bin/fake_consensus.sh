#!/bin/bash

grpc_port=$1

pid=$$
echo "pid: $pid"

echo "start consensus:"
echo `date +%Y-%m-%d-%H-%M-%S.%N`
echo "config:"
echo "grpc port $grpc_port"
cat ./consensus-log4rs.yaml
cat ./consensus-config.toml
sleep infinity
