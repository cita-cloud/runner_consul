#!/bin/bash

grpc_port=$1

pid=$$
echo "pid: $pid"

echo "start executor:"
echo `date +%Y-%m-%d-%H-%M-%S.%N`
echo "config:"
echo "grpc port $grpc_port"
cat ./executor-log4rs.yaml
sleep infinity
