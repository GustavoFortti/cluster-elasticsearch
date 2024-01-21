#!/bin/bash

export NGROK_TOKEN="2b6H4dh1PBgx1o1l1Xl0W9cZhl5_2AvNdHVqTaeurHPrcSiMM"

function elasticsearch() {
    echo "Elasticsearch LOADING..."
    sudo sysctl -w vm.max_map_count=262144

    docker-compose -f docker-compose-node-1.yml up -d

    status=$?
    if [ $status -ne 0 ]; then
        echo "Error Elasticsearch"
        exit 1
    fi
}

function ngrok() {
    echo "ngrok LOADING..."
    docker-compose -f docker-compose-ngrok.yml up -d
    # curl http://localhost:5000/api/tunnels
}

elasticsearch
# ngrok