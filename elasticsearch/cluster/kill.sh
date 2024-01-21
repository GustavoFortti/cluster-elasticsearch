#!/bin/bash

function stop_elasticsearch() {
    echo "Stopping Elasticsearch..."
    docker-compose down
}

function stop_ngrok() {
    echo "Stopping ngrok..."
    docker-compose -f docker-compose-ngrok.yml down
}

stop_elasticsearch
stop_ngrok