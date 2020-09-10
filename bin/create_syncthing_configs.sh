#!/bin/bash

set -e

if [[ $(uname) == 'Darwin' ]]; then
    ROOT_PATH=$(dirname "$(realpath "$0")")/..
else
    ROOT_PATH=$(dirname "$(readlink -f "$0")")/..
fi

chain_name="test-chain"

gui_port=8383
net_port=21999
peers=""
device_ids=""

docker network create syncthing_network >/dev/null 2>&1 || true

for node in "$ROOT_PATH"/node*
do
  if [ -d "$node" ]
  then
    gui_port=$((gui_port+1))
    net_port=$((net_port+1))
    name=$(basename "$node")
    docker run -d --rm --net syncthing_network --name "$name" -p "$gui_port":8384 -p "$net_port":22000 -v "$node":/var/syncthing syncthing/syncthing:latest -gui-apikey="$chain_name"
    sleep 5
    device_id=$(docker run --rm -v "$node":/var/syncthing syncthing/syncthing:latest -device-id)
    echo "device_id: $device_id"
    peers=${peers}$name:$net_port\;
    device_ids=${device_ids}$device_id\;
  fi
done

echo "device_ids: $device_ids  peers: $peers"
"$ROOT_PATH"/bin/gen-config4cita-cloud $chain_name "$peers" "$device_ids"

gui_port=8383
for node in "$ROOT_PATH"/node*
do
  if [ -d "$node" ]
  then
    node=$(basename "$node")
    gui_port=$((gui_port+1))
    curl -X POST -H "X-API-Key: $chain_name" http://localhost:$gui_port/rest/system/config -d@"$ROOT_PATH"/"$node"-config.json >/dev/null 2>&1 || true
  fi
done