#!/bin/bash

source ./scripts/utils.sh

export ES_VERSION=8.10.4
message "ES_VERSION=$ES_VERSION"
message "ES_CLUSTER=$ES_CLUSTER"
message "ES_NODE=$ES_NODE"
message "ES_SEEDS=$ES_SEEDS"

# bash ./setup/setup.sh
cp -r ./setup/certs ./
unzip -o ./certs/ca.zip -d ./certs/
unzip -o ./certs/certs.zip -d ./certs/
chmod -R 777 ./certs/

# docker-compose down
sudo sysctl -w vm.max_map_count=262144
docker-compose up -d
docker logs es-node-1 -f
# docker-compose down 