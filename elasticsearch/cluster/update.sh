docker cp ./config/elasticsearch.yml elasticsearch-node:/usr/share/elasticsearch/config/elasticsearch.yml

docker cp ./config/certs/* elasticsearch-node:/usr/share/elasticsearch/config/certs/*

docker restart elasticsearch-node