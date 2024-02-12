docker run -d \
    --name kibana \
    --env ELASTICSEARCH_HOSTS=http://elasticsearch:9200/ \
    --network dev_es_net \
    --publish "5601:5601" \
    --volume "$(pwd)/kibana.yml:/usr/share/kibana/config/kibana.yml" \
    docker.elastic.co/kibana/kibana:8.10.4
