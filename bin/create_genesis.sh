#!/bin/bash

if [[ $(uname) == 'Darwin' ]]; then
    ROOT_PATH=$(dirname "$(realpath "$0")")/..
else
    ROOT_PATH=$(dirname "$(readlink -f "$0")")/..
fi

# generate genesis.toml
# timestamp use milliseconds, so we need * 1000
timestamp=$(date +%s)000
prevhash="\"0x0000000000000000000000000000000000000000000000000000000000000000\""
echo -e "timestamp = ${timestamp}\nprevhash = ${prevhash}" | tee "$ROOT_PATH"/genesis.toml

# generate init_sys_config.toml
version=0
chain_id="0x0000000000000000000000000000000000000000000000000000000000000001"
admin_info=$("$ROOT_PATH"/bin/kms create -k "$ROOT_PATH"/key_file -d "$ROOT_PATH"/admin_kms.db | tail -1)
echo "${admin_info}" | cut -d ',' -f 1 | cut -d ':' -f 2 > "$ROOT_PATH"/admin_key_id
admin=$(echo "${admin_info}" | cut -d ',' -f 2 | cut -d ':' -f 2)
block_interval=3
# generate validators
validators="["
for file in "$ROOT_PATH"/chain_config/*
do
  if [ -d "$file" ]
  then
    node=$(basename "$file")
    mkdir -p "$ROOT_PATH"/"$node"
    cp -f "$ROOT_PATH"/genesis.toml "$ROOT_PATH"/"$node"/
    validator_info=$("$ROOT_PATH"/bin/kms create -k "$ROOT_PATH"/key_file -d "$ROOT_PATH"/"$node"/kms.db | tail -1)
    echo "${validator_info}" | cut -d ',' -f 1 | cut -d ':' -f 2 > "$ROOT_PATH"/"$node"/validator_key_id
    validator=$(echo "${admin_info}" | cut -d ',' -f 2 | cut -d ':' -f 2)
    validators=${validators}\"${validator}\",
  fi
done
validators=${validators}"]"

echo -e "version = ${version}\nchain_id = \"${chain_id}\"\nadmin = \"${admin}\"\nblock_interval = ${block_interval}\nvalidators = ${validators}" | tee "$ROOT_PATH"/init_sys_config.toml

# copy init_sys_config.toml to nodes
for node in "$ROOT_PATH"/node*
do
  if [ -d "$node" ]
  then
    cp -f "$ROOT_PATH"/init_sys_config.toml "$node"/
  fi
done
