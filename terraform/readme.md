## Bring up the cluster

#### Start the first docker manager

    docker swarm init --advertise-addr=eth1 --listen-addr=eth1

Log the join token for other managers:

    docker swarm join-token --quiet manager

Log the join token for workers:

    docker swarm join-token --quiet worker


#### Add other managers

    docker swarm join --advertise-addr=eth1 --token <MANAGER_TOKEN> <FIRST_MANAGER_IP>:2377

#### Add other workers

    docker swarm join --advertise-addr=eth1 --token <WORKER_TOKEN> <FIRST_MANAGER_IP>:2377
