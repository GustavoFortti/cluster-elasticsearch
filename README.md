
# 🧠 Elasticsearch Cluster with Docker and Ngrok

This repository provides a setup for deploying an **Elasticsearch Cluster** using **Docker Swarm**, with secure communication via **TLS certificates** and external exposure through **Ngrok**.

---

## 📋 Setup Instructions

### ✅ Step 1: Verify `docker-compose.yml` Configuration
- Confirm the number of Elasticsearch nodes and Ngrok instances.
- Ensure `node.name` and `node.hostname` are set for each node.

### ✅ Step 2: Register Nodes in `instances.yml`
```yaml
instances:
  - name: es-node-1
  - name: es-node-2
  - name: es-node-3
```

### ✅ Step 3: Match Hostnames
Ensure the `node.hostname` in `docker-compose.yml` matches the actual hostname of each node.

---

## 🔐 Certificate Generation and Registration

### 🛠️ Create Certificates
```bash
bash launcher.sh create_certs
```

### 💾 Commit Generated Certificates
```bash
git add .
git commit -m "certificates generated"
git push
```

### 🌍 Set Environment Variables
```bash
export ES_NODE="es-node-1"
export NGROK_TOKEN_ES="your_token_here"
```

### 🔧 Configure System Memory (Linux Only)
```bash
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```

### 📥 Register Certificates on Each Node
```bash
bash launcher.sh register_certs
```

Manual steps if needed:
```bash
sudo openssl enc -aes-256-cbc -d -pbkdf2 -in certs.tar.gz.enc -out certs.tar.gz
sudo tar -xzvf certs.tar.gz
sudo mkdir -p /etc/elasticsearch/certs
sudo cp -r ./setup/certs/$ES_NODE /etc/elasticsearch/certs
sudo cp -r ./setup/certs/ca /etc/elasticsearch/certs
```

---

## 🐳 Docker Swarm Setup

### Master Node
```bash
docker swarm init
docker swarm join-token manager -q
```

### Worker Node
```bash
docker swarm join --token YOUR_TOKEN MASTER_IP:PORT
```

### Node Management
```bash
docker node ls
docker node promote <node-name>
docker node demote <node-id>
```

---

## 🌐 Test Ngrok
```bash
docker run --name test-ngrok -p 4040:4040 -e NGROK_TOKEN=your_token_here \
  wernight/ngrok ngrok http 80 --authtoken=your_token_here --region=us --hostname=your_domain_here
```

---

## 🚀 Deploy and Manage Cluster

### Create Overlay Network
```bash
sudo docker network create --driver=overlay --attachable es_cluster
```

### Deploy Cluster
```bash
sudo docker stack deploy -c docker-compose.yml es_cluster
```

### Delete Cluster
```bash
docker stack rm es_cluster
```

---

## 🔑 Generate Elasticsearch Passwords
```bash
elasticsearch-setup-passwords auto -b
```

---

## ✅ System Verification

### Check Services
```bash
docker service ls
```

### Check Cluster Health
```bash
curl -X GET "https://your_domain_here/_cluster/health" -u elastic:your_password -H 'Content-Type: application/json'
```

### Explain Allocation
```bash
curl -X GET "https://your_domain_here/_cluster/allocation/explain" -u elastic:your_password -H 'Content-Type: application/json'
```

---

## 🧩 Post-Setup

- After initializing the cluster, **comment out `cluster.initial_master_nodes`** in the configuration.

---

## ⚠️ Important Note

**Do not restart Ngrok** without redoing the steps to maintain hostname consistency and avoid downtime.

---

## 📄 License

MIT License
