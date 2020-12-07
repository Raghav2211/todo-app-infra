#!/bin/bash

# Swarm mode using Docker Machine
read -p 'No of manager nodes: ' managers 
read -p 'No of worker nodes: ' workers 
if [ -z "$managers" ] || [ -z "$workers" ] 
then 
    echo 'Inputs cannot be blank please try again!' 
    exit 0 
fi 
# Validate input is number or not & > 0
if ! [[ "$managers" =~ ^[+-]?[1-9]+\.?[1-9]*$ ]] || ! [[ "$workers" =~ ^[+-]?[1-9]+\.?[1-9]*$ ]] 
then 
    echo "Managers/Worker nodes must be a numbers and > 0" 
    exit 0 
fi

# create manager machines
for idx in $(seq 1 $managers);
do
	docker-machine create -d virtualbox manager$idx;
done
# create worker machines
for idx in $(seq 1 $workers);
do
	docker-machine create -d virtualbox worker$idx;
done

# list all machines
docker-machine ls

# initialize swarm mode and create a manager
docker-machine ssh manager1 "docker swarm init --listen-addr $(docker-machine ip manager1) --advertise-addr $(docker-machine ip manager1)"

# get manager and worker tokens
export manager_token=`docker-machine ssh manager1 "docker swarm join-token manager -q"`
export worker_token=`docker-machine ssh manager1 "docker swarm join-token worker -q"`

echo "manager_token: $manager_token"
echo "worker_token: $worker_token"

# other masters join swarm
if [ $managers -gt 1]; then
	for node in $(seq 2 $managers);
	do
		docker-machine ssh manager$node \
			"docker swarm join \
			--token $manager_token \
			--listen-addr $(docker-machine ip manager$node) \
			--advertise-addr $(docker-machine ip manager$node) \
			$(docker-machine ip manager1)"
	done
fi

# show members of swarm
docker-machine ssh manager1 "docker node ls"

# workers join swarm
for node in $(seq 1 $workers);
do
	docker-machine ssh worker$node \
	"docker swarm join \
	--token $worker_token \
	--listen-addr $(docker-machine ip worker$node) \
	--advertise-addr $(docker-machine ip worker$node) \
	$(docker-machine ip manager1)"
done

# show members of swarm
docker-machine ssh manager1 "docker node ls"

