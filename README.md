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
    **Configuration** 

    The following table lists the configurable parameters of the TodoApp swarm cluster and their default values.
    
    Parameter | Description | Default
      --- | --- | ---
    `TODO_IMAGE_TAG` | Image tag for Todo-App | `latest`
    `BASIC_AUTH_ENABLE` | Enable spring Basic-Auth | `false`
    `BASIC_AUTH_USERNAME` | Username of Basic-Auth | ``
    `BASIC_AUTH_PASSWORD` | Password of Basic-Auth | ``
    `MYSQL_IMAGE_TAG` | Image tag for Mysql | `8.0.22`
    `MYSQL_USER` | Username of new user to create | ``
    `MYSQL_PASSWORD` | Password for the new user | ``
    `MYSQL_ROOT_PASSWORD` | Password for the root user | ``
    `MYSQL_DATABASE` | Name for new database to create | ``
    `MYSQL_DATA_SRC_PATH` | Host path for persistence mysql data | ``

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



