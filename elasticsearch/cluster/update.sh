docker cp ./config/elasticsearch.yml elasticsearch-node:/usr/share/elasticsearch/config/elasticsearch.yml

docker cp ./config/http_ca.crt elasticsearch-node:/usr/share/elasticsearch/config/certs/http_ca.crt

docker restart elasticsearch-node