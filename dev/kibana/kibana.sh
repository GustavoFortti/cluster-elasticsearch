docker run -d \
    --name kibana \
    --env ELASTICSEARCH_HOSTS=https://dataindex-els-1.ngrok.app \
    --env ELASTICSEARCH_SSL_CERTIFICATEAUTHORITIES=/usr/share/kibana/config/certs/ca/ca.crt \
    --publish "5601:5601" \
    --volume "$(pwd)/kibana.yml:/usr/share/kibana/config/kibana.yml" \
    --volume "/etc/elasticsearch/certs/ca/ca.crt:/usr/share/kibana/config/certs/ca/ca.crt" \
    docker.elastic.co/kibana/kibana:8.10.4


curl -X POST "https://seu_elasticsearch:9200/_security/oauth2/token" -H "Content-Type: application/x-www-form-urlencoded" -d "grant_type=password&username=kibana&password=sua_senha_aqui"
