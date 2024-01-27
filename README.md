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
    export ES_NODE="es-node-*"
    export NGROK_TOKEN_ES="TOKEN"
    export NGROK_TOKEN_KIBANA="TOKEN"
```

# Configurar uso de memoria do Elastic no nó
```
    echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```

# Registrar certificado no nó
```
    bash launcher.sh register_certs
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

# Deploy do cluster
```
    docker stack deploy -c docker-compose.yml es_cluster
```

# Deletar cluster
```
    docker stack rm es_cluster 
```

# Verificar sistema

```
    docker service ls
    
    curl -X GET "https://dataindex-els-1.ngrok.app/_cluster/health" -u elastic:SENHA -H 'Content-Type: application/json'
    
    curl -X GET "https://dataindex-els-1.ngrok.app/_cluster/allocation/explain" -u elastic:SENHA -H 'Content-Type: application/json'
```
