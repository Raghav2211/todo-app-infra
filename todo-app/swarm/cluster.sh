#!/bin/bash

me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

function create_cluster () {

	# Input manager & worker nodes
	read -p 'No of manager nodes: ' managers 
	read -p 'No of worker nodes: ' workers 
	if [ -z "$managers" ] || [ -z "$workers" ] 
	then 
	    echo 'Inputs cannot be blank please try again!' 
	    exit 1 
	fi 
	# Validate input is number or not & > 0
	if ! [[ "$managers" =~ ^[+-]?[1-9]+\.?[1-9]*$ ]] || ! [[ "$workers" =~ ^[+-]?[1-9]+\.?[1-9]*$ ]] 
	then 
	    echo "Managers/Worker nodes must be a numbers and > 0" 
	    exit 1 
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

	docker-machine ssh manager1 "docker swarm init --listen-addr $(docker-machine ip manager1) --advertise-addr $(docker-machine ip manager1)"

	export manager_token=`docker-machine ssh manager1 "docker swarm join-token manager -q"`
	export worker_token=`docker-machine ssh manager1 "docker swarm join-token worker -q"`

	echo "manager_token: $manager_token"
	echo "worker_token: $worker_token"

	if [ $managers -gt 1 ]; then
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

	docker-machine ssh manager1 "docker node ls"

	for node in $(seq 1 $workers);
	do
		docker-machine ssh worker$node \
		"docker swarm join \
		--token $worker_token \
		--listen-addr $(docker-machine ip worker$node) \
		--advertise-addr $(docker-machine ip worker$node) \
		$(docker-machine ip manager1)"
	done

	docker-machine ssh manager1 "docker node ls"
}

function delete_cluster () {
    {	
		read
		while read -r name active driver state url swarm docker error
		do
		    docker-machine rm -y $name
		done
	} < <(docker-machine ls)
}

function help() {
    echo "Usage:    ${me} [-hcd]  [-h help] [-c create_cluster] [-d delete_cluster] "
}
if [ $# -eq 0 ]
then
        help
fi
case $1 in

    --create|-c)
            create_cluster
            ;;
	--delete|-d)
            delete_cluster
            ;;            
    --help|-h)
            help
            ;;
     *)
			echo "Unrecognized option: ${1}"
			help
     		exit 1
     		;;       

esac

