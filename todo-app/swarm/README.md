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
   
 - Link host docker client to the VM's docker daemon
 
    ```bash
       $ eval $(docker-machine env manager1)
    ```
 - Build
 
    [Build & Create Docker Image](../README.md#build)
 
 - Deploy stack
          
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
