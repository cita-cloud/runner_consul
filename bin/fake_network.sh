#!/bin/bash

network_grpc_port=$1

echo "start network:"
echo `date +%Y-%m-%d-%H-%M-%S.%N`
echo "config:"
echo "grpc port $network_grpc_port"
cat ./network.toml
cat ./privkey
cat ./network-log4rs.yaml
sleep infinity