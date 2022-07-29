# TODO APP INFRA
[![Terraform Check](https://github.com/Raghav2211/todo-app-infra/actions/workflows/terraform-check.yml/badge.svg)](https://github.com/Raghav2211/todo-app-infra/actions/workflows/terraform-check.yml)

Repo contain IAC to deploy [todo-app](https://github.com/Raghav2211/spring-web-flux-todo-app.git) in different environment 

## TASK LIST ##
- [X] Todo App deployment on local using docker-compose
- [X] Todo App deployment on local using swarm
- [X] Todo App deployment on local k8s using Helm
- [X] Todo App deployment on AWS on EC2
- [X] Todo App deployment on AWS using eks

## Deploy ##
1. Deployment using docker-compose
   - Install

     ```bash
      $ docker-compose --env-file=env/<env>/Docker.env up -d 

      # Override default docker-compose configuration
      $ docker-compose --env-file=env/<env>/Docker.env -f docker-compose.yaml -f env/<env>/docker-compose-override.yml up -d
     ```    

   - Access

      http://localhost:8081  # get access_token

      http://localhost:8080/webjars/swagger-ui/index.html # use access_token to access the API(s)

   - Uninstall

        ```bash
        $ docker-compose down
        ```
    Configuration

      The following table lists the configurable parameters of the TodoApp swarm cluster and their default values.
    
      Parameter | Description | Default
      --- | --- | ---
      `TODO_IMAGE_TAG` | Image tag for Todo-App | `2.0.0`
      `EDGE_SERVICE_IMAGE_TAG` | Image tag for Edge Service | `1.0.0`
      `CONFIG_SERVER_IMAGE_TAG` | Image tag for Config Server | `1.0.0`
      `MONGO_DATA_SRC_PATH` | Host path for persistence mongo data | ``  

2. On swarm cluster using docker stack
[Swarm](swarm/README.md)
3. On k8s using minikube
[K8s](k8s/README.md)
4. On EC2 using packer
[EC2](aws/v1_0_0.md)
5. On EKS
[EKS](aws/v2_0_0.md)



