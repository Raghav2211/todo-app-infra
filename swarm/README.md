# Deploy Todo Application in swarm cluster

- Local Deployment

## Local Deployment ##

- Setup cluster

   Install  Dependencies and run cluster

    ```bash
       # Install all dependencies for local cluster
       $ bash install-dependencies.sh all
       
       # Boot local cluster [ Swarm Manager(s)/Worker(s) node ]
       $ bash cluster.sh create local
    ```
   **Note** If you find problem related to `VboxManage Access denied` then follow the steps mention in this [link](https://stackoverflow.com/questions/70281938/docker-machine-unable-to-create-a-machine-on-macos-vboxmanage-returning-e-acces)

   Verify cluster 

    ```bash
       $ bash cluster.sh view local
       ------------------------------------------------------------Nodes------------------------------------------------------------
       ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
       zsrfmw8g8wavf8nsq1uo8xz7j *   manager1            Ready               Active              Leader              19.03.12
       quwa5fhv5vk7cuzw8m88prj8m     worker1             Ready               Active                                  19.03.12
       ------------------------------------------------------------Vm(s)------------------------------------------------------------
       NAME       ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER      ERRORS
       manager1   *        virtualbox   Running   tcp://192.168.99.149:2376           v19.03.12   
       worker1    -        virtualbox   Running   tcp://192.168.99.150:2376           v19.03.12 
    ```
   
   
 - Link host docker client to the VM's docker daemon
 
    ```bash
   
       # save local images 
       $ docker save todo:${TODO_APP_VERSION} | gzip > todo.tgz
       $ docker save edge-service:${EDGE_SERVICE_VERSION} | gzip > edge.tgz
       $ docker save config-server:${CONFIG_SERVER_VERSION} | gzip > config.tgz 
        
       $ eval $(docker-machine env manager1)
       
       # load images in virtual box docker daemon env
       $ docker load -i todo.tgz
       $ docker load -i edge.tgz
       $ docker load -i config.tgz  
    ```
 
 - Deploy the Stack
          
    ```bash
     
    # If you want to use local registry instead of ghcr 
    $ docker service create --name registry --publish 5000:5000 registry:2
    
    # Build & tag
    $ docker tag config-server:${CONFIG_SERVER_VERSION} localhost:5000/config-server 
    $ docker tag todo:${TODO_APP_VERSION} localhost:5000/todo
    $ docker tag edge-service:${EDGE_SERVICE_VERSION} localhost:5000/edge-service
    
    # Push the image to the local registry running at localhost:5000
    $ docker push localhost:5000/config-server
    $ docker push localhost:5000/todo
    $ docker push localhost:5000/edge-service
   
     
    # Deploy todo app cluster 
    $ docker stack deploy -c <(docker-compose --env-file=../env/<env>/Docker.env -f ../docker-compose.yaml -f ../env/<env>/docker-stack-compose-override.yml config) todo
    
    # or 
    # Apply persistent with mongo 
    docker stack deploy -c <(docker-compose --env-file=../env/local/Docker.env -f ../docker-compose.yaml -f ../env/local/docker-stack-compose-override.yml -f ../env/local/docker-stack-persistent-compose-override.yml config) todo
    
    ```

 - Verify all service up & running 
 
    ```bash
      $ docker service ls 
       
      ID             NAME                MODE         REPLICAS   IMAGE                                PORTS
    a5xtv1s0jtm9   registry            replicated     1/1        registry:2                           *:5000->5000/tcp
    eg08gas6wgzd   todo_config-server  replicated     1/1        localhost:5000/config-server:latest   
    0wqkzciwyjp7   todo_edge-service   replicated     1/1        localhost:5000/edge-service:latest   *:8081->8081/tcp
    dxrgqsmjafwa   todo_mongo          replicated     1/1        mongo:4.2.21                         *:27017->27017/tcp
    xyy9feyvm75l   todo_todo           replicated     1/1        localhost:5000/todo:latest           *:8080->8080/tcp 
   

    ```

 - Access
 
   http://localhost:8081  # get access_token 
   
   http://localhost:8080/webjars/swagger-ui/index.html # use access_token to access the API(s)
    
 - Uninstalling the Stack 
 
   ```bash
     
       # Remove locally cached images 
      $ docker rmi -f $(docker images -aq)
      
      # remove stack
      $ docker stack rm todo
      $ docker service rm registry
      $ eval $(docker-machine env -u) 
      $ bash cluster.sh delete local 
    ```
    
 - Configuration
  
   The following table lists the configurable parameters of the TodoApp swarm cluster and their default values.

   Parameter | Description | Default
   --- | --- | ---
   `TODO_REPLICA` | No of replica for Todo-app | `1`
   `TODO_STACK_IMAGE` | Todo-app Image | `localhost:5000/todo`
   `EDGE_SERVICE_REPLICA` | No of replica for Edge-service | `1`
   `EDGE_SERVICE_STACK_IMAGE` | Edge-service Image | `localhost:5000/edge-service`
   `CONFIG_SERVER_REPLICA` | No of replica for Config-Server | `1`
   `CONFIG_SERVER_STACK_IMAGE` | Config-Server Image | `localhost:5000/config-server` 
   `MONGO_DATA_SRC_PATH` | Host path for persistence mongo data | ``
      
