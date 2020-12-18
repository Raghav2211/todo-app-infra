#!/bin/bash

me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

function create_cluster() {

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
  	eval $(if [ "$debug" -eq 1 ]; then echo "docker-machine --debug"; else echo "docker-machine"; fi) create -d virtualbox --virtualbox-no-vtx-check manager$idx;
  done
  # create worker machines
  for idx in $(seq 1 $workers);
  do
  	eval $(if [ "$debug" -eq 1 ]; then echo "docker-machine --debug"; else echo "docker-machine"; fi) create -d virtualbox --virtualbox-no-vtx-check worker$idx;
  done

  eval $(if [ "$debug" -eq 1 ]; then echo "docker-machine --debug"; else echo "docker-machine"; fi) ssh manager1 "docker swarm init --listen-addr $(docker-machine ip manager1) --advertise-addr $(docker-machine ip manager1)"

  export manager_token=`eval $(if [ "$debug" -eq 1 ]; then echo "docker-machine --debug"; else echo "docker-machine"; fi) ssh manager1 "docker swarm join-token manager -q"`
  export worker_token=`eval $(if [ "$debug" -eq 1 ]; then echo "docker-machine --debug"; else echo "docker-machine"; fi) ssh manager1 "docker swarm join-token worker -q"`

  echo "manager_token: $manager_token"
  echo "worker_token: $worker_token"

  if [ $managers -gt 1 ]; then
    for node in $(seq 2 $managers);
    do
      eval $(if [ "$debug" -eq 1 ]; then echo "docker-machine --debug"; else echo "docker-machine"; fi) ssh manager$node \
        "docker swarm join \
        --token $manager_token \
        --listen-addr $(docker-machine ip manager$node) \
        --advertise-addr $(docker-machine ip manager$node) \
        $(docker-machine ip manager1)"
    done
  fi

  for node in $(seq 1 $workers);
  do
    eval $(if [ "$debug" -eq 1 ]; then echo "docker-machine --debug"; else echo "docker-machine"; fi) ssh worker$node \
    "docker swarm join \
    --token $worker_token \
    --listen-addr $(docker-machine ip worker$node) \
    --advertise-addr $(docker-machine ip worker$node) \
    $(docker-machine ip manager1)"
  done
  exit 0;
  
}

function view_cluster() {
  docker-machine ls -q | grep '^manager1$'> /dev/null || { echo "No manager node exit"; exit 1; }
  echo -e "------------------------------------------------------------\033[1mNodes\033[0m------------------------------------------------------------"
  docker-machine ssh manager1 "docker node ls"
  echo -e "------------------------------------------------------------\033[1mVm(s)\033[0m------------------------------------------------------------"
  docker-machine ls 
  exit 0;
}

function delete_cluster() {
    { 
    read
    while read -r name active driver state url swarm docker error
    do
        docker-machine rm -y $name
    done
  } < <(eval $(if [ "$debug" -eq 1 ]; then echo "docker-machine --debug"; else echo "docker-machine"; fi) ls)
  exit 0;
}

function help() {
   	echo "Usage:    ${me} [OPTIONS] COMMAND"
    echo ""
    echo "Author:"
    echo "   PSI Lab Contributors - <$(git config --get remote.origin.url)>"
    echo ""
    echo "Options:"
    echo " --debug, -D                    Enable debug mode"
    echo " --help, -h                     show help"
    echo ""
    echo "Commands:"
    echo " create <env>                   Create a new cluster with specify manager/worker nodes for specific environment"
    echo " delete <env>                   Delete clsuter for specific environment"
    echo " view   <env>                   View clsuter for specific environment"

}

debug=0 # disable debug 

if [ $# -lt 1 ]; then
    help
fi

while test -n "$1"; do
   case "$1" in
      --debug|-D)
		 if [[ $# -eq 1 ]]; then
		 	help
		 fi	
         debug=1 # enable debug 
         shift
         ;;
       create)
         if [[ $# -gt 2 ]]; then
          echo "Too many args";
          exit 1;
         elif [[ $# -lt 2 ]]; then
          help
          exit 1;	   
         fi   
         case $2 in
			 local)
			  	create_cluster
			  	;;
			  *)
			  	echo "Unrecognized option: ${2}"
			  	help
			  	exit 1
			  	;;
		 esac  	
         shift
         ;;  
       delete)
         if [[ $# -gt 2 ]]; then
          echo "Too many args";
          exit 1;
         elif [[ $# -lt 2 ]]; then
          help
          exit 1;	   
         fi   
         case $2 in
			 local)
			  	delete_cluster
			  	;;
			  *)
			  	echo "Unrecognized option: ${2}"
			  	help
			  	exit 1
			  	;;
		 esac  	
         shift
         ;;  
       view)
         if [[ $# -gt 2 ]]; then
          echo "Too many args";
          exit 1;
         elif [[ $# -lt 2 ]]; then
          help
          exit 1;	   
         fi   
         case $2 in
			 local)
			  	view_cluster
			  	;;
			  *)
			  	echo "Unrecognizedd option: ${2}"
			  	help
			  	exit 1
			  	;;
		 esac  	
         shift
         ;;  
        --help|-h)
          help
          shift
          ;; 
       *) 
			
          echo "Unrecognizedd option : ${1}"
          help
          exit 1;  
   esac
done
debug=0  # disable debug 