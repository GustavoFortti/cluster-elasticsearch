
# Elasticsearch Cluster Setup

## Verify `docker-compose.yml` Cluster Configuration
- [ ] Check the number of Elasticsearch nodes and Ngrok instances.
- [ ] Ensure `node.hostname` is configured for each node.

## Register Nodes in `instances.yml`
Example:
```yaml
instances:
  - name: es-node-1
  - name: es-node-2
  - name: es-node-3
```

## Update Hostname in `docker-compose.yml`
```yaml
- node.hostname == hostname
```

## Create Certificates
```bash
bash launcher.sh create_certs
```

## Commit Certificates
```bash
git add .
git commit -m "certificates generated"
git push
```

## Set Environment Variables for Each Node
```bash
export ES_NODE="es-node-1"
export NGROK_TOKEN_ES="your_token_here"
```

## Configure Memory Usage for Elasticsearch
```bash
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```

## Register Certificate on Each Node
```bash
bash launcher.sh register_certs

sudo openssl enc -aes-256-cbc -d -pbkdf2 -in certs.tar.gz.enc -out certs.tar.gz
sudo tar -xzvf certs.tar.gz
sudo mkdir -p /etc/elasticsearch/certs
sudo cp -r ./setup/certs/$ES_NODE /etc/elasticsearch/certs
sudo cp -r ./setup/certs/ca /etc/elasticsearch/certs
```

## Docker Swarm Registration

### On the Master Node
```bash
docker swarm init

docker swarm join-token manager -q
```

### On the Worker Node
```bash
docker swarm join --token YOUR_TOKEN MASTER_IP:PORT

# Verify nodes
docker node ls

# Promote a node to manager
docker node promote <node-name>

# Demote a manager node
docker node demote <node-id>
```

## Test Ngrok
```bash
docker run --name test-ngrok -p 4040:4040 -e NGROK_TOKEN=your_token_here   wernight/ngrok ngrok http 80 --authtoken=your_token_here --region=us --hostname=your_domain_here
```

## Deploy the Cluster
```bash
sudo docker network create --driver=overlay --attachable es_cluster

sudo docker stack deploy -c docker-compose.yml es_cluster
```

## Delete the Cluster
```bash
docker stack rm es_cluster
```

## Generate Elasticsearch Passwords
```bash
elasticsearch-setup-passwords auto -b
```

## Verify the System
```bash
docker service ls

curl -X GET "https://your_domain_here/_cluster/health"   -u elastic:your_password -H 'Content-Type: application/json'

curl -X GET "https://your_domain_here/_cluster/allocation/explain"   -u elastic:your_password -H 'Content-Type: application/json'
```

## Post-Cluster Setup
- Comment out `cluster.initial_master_nodes` in the configuration after the cluster is initialized.

## Important Note
- Never restart Ngrok without following the appropriate steps.
