#!/bin/bash

source ./scripts/utils.sh

export ES_VERSION=8.10.4
message "ES_VERSION=$ES_VERSION"

function gen_certs() {
    bash ./setup/setup.sh
    cp -r ./setup/certs ./
    unzip -o ./certs/ca.zip -d ./certs/
    unzip -o ./certs/certs.zip -d ./certs/
    chmod -R 777 ./certs/
}