sudo sysctl -w vm.max_map_count=262144
docker-compose up

# docker swarm join --token SWMTKN-1-3tkbtmekb33md2v48jmse2a30lv01k8trnzgsttm3vhcufx9ci-2z3narmd33t9y4528kkl1ilep 192.168.0.102:2377
# docker stack deploy -c docker-compose.yml elasticsearch