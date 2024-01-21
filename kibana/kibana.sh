docker run -d \
    --name kibana \
    --env ELASTICSEARCH_HOSTS=https://6e54-54-39-132-231.ngrok-free.app/ \
    --publish "5601:5601" \
    --volume "$(pwd)/kibana.yml:/usr/share/kibana/config/kibana.yml" \
    docker.elastic.co/kibana/kibana:8.10.4

docker logs kibana
