#!/bin/bash

function stop_elasticsearch() {
    echo "Stopping Elasticsearch..."
    docker rm elasticsearch-node-1 --force 
    docker rm elasticsearch-node-2 --force 
    docker-compose down
    docker volume rm cluster_elasticsearch-data
}

function stop_ngrok() {
    echo "Stopping ngrok..."
    docker-compose -f docker-compose-ngrok.yml down
}

stop_elasticsearch
stop_ngrok