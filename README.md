### Cluster elasticsearch

# Conferir cluster/docker-compose.yml
    [] - Quantidade de nó elastic e ngrok
    [] - node.hostname que será executado cada nó

# Cadastrar Nós no arquivo instances.yml ex:
```
    instances:
      - name: es-node-1
      - name: es-node-2
      - name: es-node-3
```

# Mudar hostname no docker-compose.yml
```
    - node.hostname == hostname
```

# Criar certificados
```
    bash launcher.sh create_certs
```

# Commit dos certificados
```
    git add .
    git commit -m "certificados gerados"
    git push
```

# Cadastrar variaveis de ambiente no nó
```
    export ES_NODE="es-node-1"
    export NGROK_TOKEN_ES="token"
```

# Configurar uso de memoria do Elastic no nó
```
    echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```

# Registrar certificado no nó
```
    bash launcher.sh register_certs

    sudo openssl enc -aes-256-cbc -d -pbkdf2 -in certs.tar.gz.enc -out certs.tar.gz
    sudo tar -xzvf certs.tar.gz
    sudo mkdir -p /etc/elasticsearch/certs
    sudo cp -r ./setup/certs/$ES_NODE /etc/elasticsearch/certs
    sudo cp -r ./setup/certs/ca /etc/elasticsearch/certs

```

## Registro Docker Swarm

# Executar na Master
```
    docker swarm init

    docker swarm join-token manager -q
```

# Executar no Nó
```
    docker swarm join --token SEU_TOKEN IP_DO_MASTER:PORTA

    # verificar nós
    docker node ls

    # criar uma 2 master
    docker node promote <node-name>

    # remover master
    docker node demote <node-id>

```

# Teste o NGROK
```
    docker run --name teste-ngrok -p 4040:4040 -e NGROK_TOKEN=2Z8nEtOKM1hyByza71PY5cwyrvs_4b5qN3PMKwUGKUw43hsmz wernight/ngrok ngrok http 80 -authtoken=2Z8nEtOKM1hyByza71PY5cwyrvs_4b5qN3PMKwUGKUw43hsmz --region=us --hostname=__DOMINIO__
```


# Deploy do cluster
```
    sudo docker network create --driver=overlay --attachable es_cluster

    sudo docker stack deploy -c docker-compose.yml es_cluster
```

# Deletar cluster
```
    docker stack rm es_cluster 
```

# Gerar senhas do Elastic
```
    elasticsearch-setup-passwords auto -b 
```

# Verificar sistema

```
    docker service ls
    
    curl -X GET "https://__DOMINIO__/_cluster/health" -u elastic:SENHA -H 'Content-Type: application/json'
    
    curl -X GET "https://__DOMINIO__/_cluster/allocation/explain" -u elastic:SENHA -H 'Content-Type: application/json'
```
