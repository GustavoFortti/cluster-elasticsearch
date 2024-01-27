#!/bin/bash

source ./scripts/utils.sh

export ES_VERSION=8.10.4
message "ES_VERSION=$ES_VERSION"

function create_certs() {
    message "Creating certs"
    bash ./setup/setup.sh
}

function register_certs() {
    message "Register certs"
    openssl enc -aes-256-cbc -d -pbkdf2 -in certs.tar.gz.enc -out certs.tar.gz
    tar -xzvf certs.tar.gz

    CERTS_DIR=/etc/elasticsearch/certs

    if [ ! -e "$CERTS_DIR" ]; then
        sudo mkdir -p $CERTS_DIR/
        sudo cp ./setup/certs/$ES_NODE $CERTS_DIR
        sudo cp ./setup/certs/ca $CERTS_DIR/
    fi

    rm -r ./setup/certs
    rm -r ./certs.tar.gz
}

create_certs