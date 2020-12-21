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
       $ eval $(docker-machine env manager1)
    ```
 - Build
 
    [Build & Create Docker Image](../README.md#build)
 
 - Deploy the Stack
          
    ```bash
    # Local registry
    $ docker service create --name registry --publish 5000:5000 registry:2
    
    # Tag the image as localhost:5000/psi-todo. This creates an additional tag for the existing image.
    $ docker tag psi-todo:1.0.0 localhost:5000/psi-todo
    
    # Push the image to the local registry running at localhost:5000
    $ docker push localhost:5000/psi-todo
    
    # Remove locally cached images
    $ docker image remove psi-todo
    $ docker image remove psi-todo:1.0.0
    $ docker image remove localhost:5000/psi-todo
    
    # Deploy todo app cluster 
    $ docker stack deploy -c <(docker-compose --env-file=env/<env>/Docker.env -f docker-compose.yaml -f env/<env>/docker-stack-compose-override.yml config) psi-todo
    
    # or 
    # Apply persistent with mysql 
    docker stack deploy -c <(docker-compose --env-file=env/local/Docker.env -f docker-compose.yaml -f env/local/docker-stack-compose-override.yml -f env/local/docker-stack-persistent-compose-override.yml config) psi-todo
    
    ```

 - Verify all service up & running 
 
    ```bash
      $ docker service ls 
       ID                  NAME                  MODE                REPLICAS            IMAGE                            PORTS
       x2or6oc3lkes        psi-todo_psimysql     replicated          1/1                 mysql:8.0.22                     
       zd2vezg73ksd        psi-todo_psitodoapp   replicated          1/1                 localhost:5000/psi-todo:latest   *:8080->8080/tcp
       ac6h0l8eg3ko        registry              replicated          1/1                 registry:2                       *:5000->5000/tcp

    ```

 - Access swagger api endpoint with below url.
 
    http://localhost:8080/swagger-ui/
    
 - Uninstalling the Stack 
 
    
    ```bash
       $ docker stack rm psi-todo
    ```   
    
  - Configuration
  
    The following table lists the configurable parameters of the TodoApp swarm cluster and their default values.

    Parameter | Description | Default
    --- | --- | ---
    `PSI_TODO_REPLICA` | No of replica for Todo-app | `1`
    `PSI_TODO_STACK_IMAGE` | Todo-app Image | `localhost:5000/psi-todo`    
    `BASIC_AUTH_ENABLE` | Enable spring Basic-Auth | `false`        
    `BASIC_AUTH_USERNAME` | Username of Basic-Auth | ``                    
    `BASIC_AUTH_PASSWORD` | Password of Basic-Auth | ``                            
    `MYSQL_IMAGE_TAG` | Image tag for Mysql | `8.0.22`                                    
    `MYSQL_USER` | Username of new user to create | `root`        
    `MYSQL_PASSWORD` | Password for the new user | `root`            
    `MYSQL_DATABASE` | Name for new database to create | `psi`                
    `MYSQL_DATA_SRC_PATH` | Host path for persistence mysql data | ``                    
    `MYSQL_DATA_DEST_PATH` | Mount directory path in mysql container | `/var/lib/mysql`                        
      
