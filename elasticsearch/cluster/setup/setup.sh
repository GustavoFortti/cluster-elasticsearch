#!/bin/bash

source ./scripts/utils.sh
export SETUP_CONTAINER=elasticsearch-setup
export PATH_LOCAL=$(pwd)/setup

function elasticsearch_setup() {
    sudo sysctl -w vm.max_map_count=262144
    message "CRIANDO CONTAINER DE CONFIGURAÇÃO"
    docker-compose -f $PATH_LOCAL/docker-compose.yml up -d

    message "LOG DO CONTAINER"
    docker logs $SETUP_CONTAINER | tail -n 10

    CERTS_PATH="/usr/share/elasticsearch/config/certs"
    mkdir ./setup/certs
    docker exec -it $SETUP_CONTAINER mkdir -p $CERTS_PATH

    message "Creating CA"
    docker exec -it $SETUP_CONTAINER bin/elasticsearch-certutil ca --silent --pem -out $CERTS_PATH/ca.zip
    docker cp $SETUP_CONTAINER:$CERTS_PATH/ca.zip $PATH_LOCAL/certs/

    docker exec -it $SETUP_CONTAINER unzip $CERTS_PATH/ca.zip -d $CERTS_PATH/
    docker cp $PATH_LOCAL/instances.yml $SETUP_CONTAINER:$CERTS_PATH/

    docker exec -it $SETUP_CONTAINER bin/elasticsearch-certutil cert --silent --pem -out $CERTS_PATH/certs.zip --in $CERTS_PATH/instances.yml --ca-cert $CERTS_PATH/ca/ca.crt --ca-key $CERTS_PATH/ca/ca.key;
    docker cp $SETUP_CONTAINER:$CERTS_PATH/certs.zip $PATH_LOCAL/certs/

    unzip -o $PATH_LOCAL/certs/ca.zip -d $PATH_LOCAL/certs/
    unzip -o $PATH_LOCAL/certs/certs.zip -d $PATH_LOCAL/certs/
    chmod -R 777 $PATH_LOCAL/certs/
    tar -czvf ./certs.tar.gz ./setup/certs

    openssl enc -aes-256-cbc -salt -pbkdf2 -in ./certs.tar.gz -out certs.tar.gz.enc
    # rm -f ./certs.tar.gz
    # rm -r  $PATH_LOCAL/certs

    docker rm $SETUP_CONTAINER --force
    docker-compose -f $PATH_LOCAL/docker-compose.yml down

    message "Success to create certs!"
}

elasticsearch_setup