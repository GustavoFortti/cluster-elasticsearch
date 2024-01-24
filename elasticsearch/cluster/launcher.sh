#!/bin/bash

source ./scripts/utils.sh

export ES_VERSION=8.10.4
message "ES_VERSION=$ES_VERSION"
message "ES_CLUSTER=$ES_CLUSTER"
message "ES_NODE=$ES_NODE"
message "NODE_IP=$NODE_IP"
message "ES_SEEDS=$ES_SEEDS"

# bash ./setup/setup.sh
cp -r ./setup/certs ./
unzip -o ./certs/ca.zip -d ./certs/
unzip -o ./certs/certs.zip -d ./certs/

# docker-compose down
sudo sysctl -w vm.max_map_count=262144
docker-compose up -d
docker logs es-node-1 -f
docker-compose down 

# loading_bar 30

# LOCAL_CERTS_PATH=$(pwd)/setup/certs
# LOCAL_CONFIG_PATH=/usr/share/elasticsearch/config
# CONFIG_PATH=/usr/share/elasticsearch/config
# CERTS_PATH=/usr/share/elasticsearch/config/certs

# for file in $LOCAL_CERTS_PATH/*; do
#     docker cp "$file" "$ES_NODE:$CERTS_PATH/"
# done
# docker cp $LOCAL_CONFIG_PATH/$ES_NODE.yml $ES_NODE:$CONFIG_PATH/