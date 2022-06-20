# TODO APP INFRA

Repo contain IAC to deploy [todo-app](https://github.com/Raghav2211/spring-web-flux-todo-app.git) in different environment 

## TASK LIST ##
- [X] Todo App deployment on local using docker-compose
- [X] Todo App deployment on local using swarm
- [X] Todo App deployment on local k8s using Helm
- [X] Todo App deployment on AWS on EC2
- [ ] Todo App deployment on AWS using eks

## Deploy ##
1. Deployment using docker-compose
- Install

     ```bash
     docker-compose --env-file=env/<env>/Docker.env up -d
     #or 
     # Override default docker-compose configuration
     docker-compose --env-file=env/<env>/Docker.env -f docker-compose.yaml -f env/<env>/docker-compose-override.yml up -d
     ```
- Uninstall

     ```bash
     docker-compose down
     ```
2. On swarm cluster using docker stack
[Swarm](swarm/README.md)
3. On k8s using minikube
[K8s](k8s/README.md)
4. On EC2 using packer
[EC2](aws/README.md)
5. On EKS [TODO]



