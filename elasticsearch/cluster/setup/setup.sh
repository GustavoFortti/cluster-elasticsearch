#!/bin/bash

source ./scripts/utils.sh
export SETUP_CONTAINER=elasticsearch-setup
export SETUP_LOCAL=$(pwd)/setup

function elasticsearch_setup() {
    sudo sysctl -w vm.max_map_count=262144

    message "CRIANDO CONTAINER DE CONFIGURAÇÃO"
    docker-compose -f $SETUP_LOCAL/docker-compose.yml up -d

    loading_bar 30
    message "LOG DO CONTAINER"
    docker logs $SETUP_CONTAINER | tail -n 10

    message "GERANDO SENHAS DO SISTEMA"
    docker exec -it $SETUP_CONTAINER bin/$SETUP_CONTAINER-passwords auto -b > $SETUP_LOCAL/env.conf

    CERTS_PATH="/usr/share/elasticsearch/config/certs"

    if [ ! -e "$SETUP_LOCAL/certs/ca.zip" ]; then
        message "Creating CA"
        docker exec -it $SETUP_CONTAINER bin/elasticsearch-certutil ca --silent --pem -out $CERTS_PATH/ca.zip
        docker cp $SETUP_CONTAINER:$CERTS_PATH/ca.zip $SETUP_LOCAL/certs/
    else
        message "Copying CA ZIP file to container"
        docker cp $SETUP_LOCAL/certs/ca.zip $SETUP_CONTAINER:$CERTS_PATH/ca.zip
    fi

    docker exec -it $SETUP_CONTAINER unzip $CERTS_PATH/ca.zip -d $CERTS_PATH/
    docker cp $SETUP_LOCAL/instances.yml $SETUP_CONTAINER:$CERTS_PATH/

    docker exec -it $SETUP_CONTAINER bin/elasticsearch-certutil cert --silent --pem -out $CERTS_PATH/certs.zip --in $CERTS_PATH/instances.yml --ca-cert $CERTS_PATH/ca/ca.crt --ca-key $CERTS_PATH/ca/ca.key;
    docker cp $SETUP_CONTAINER:$CERTS_PATH/certs.zip $SETUP_LOCAL/certs/

    message "Success to create certs!"
}

function kill_elasticsearch_setup() {
    docker rm $SETUP_CONTAINER --force
    docker network rm $SETUP_CONTAINER
    docker-compose -f $SETUP_LOCAL/docker-compose.yml down
}

kill_elasticsearch_setup
elasticsearch_setup
kill_elasticsearch_setup