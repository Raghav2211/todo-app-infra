# Deploy Todo Application in K8s cluster using helm

- Setup minikube  
    https://minikube.sigs.k8s.io/docs/start/    

 - Link host docker client to the VM's docker daemon
 
 ```bash
    eval $(minikube docker-env)
 ```
 - Build
 
    [Build & Create Docker Image](../README.md#build)
 
 - Deploy  mysql
 
    ```bash
       helm install mysql ./mysql -f env/<env>/mysql-secret.yaml
    ```
    or
    
    ```bash
       helm install mysql ./mysql -f env/<env>/mysql-secret.yaml -f env/<env>/mysql-values.yaml
    ```
    
 - Deploy Todo-app    
 
    ```bash
       helm install klab-todo ./klab-todo -f env/<env>/klab-todo-secret.yaml
    ```  
    or
    
    ```bash
       helm install klab-todo ./klab-todo -f env/<env>/klab-todo-secret.yaml -f env/<env>/klab-todo-values.yaml
    ```  

 - Verify all pods are up and running
 
 ```bash
   $ kubectl get pods
    NAME                         READY   STATUS    RESTARTS   AGE
    klab-todo-6f4f69b7d7-8t8kg   1/1     Running   0          92m
    mysql-58b87bf444-pshmk       1/1     Running   0          92m
    
 ```

 - Execute below command in a separate terminal which creates a route to services deployed with type LoadBalancer and sets their Ingress to their ClusterIP.

 ```bash
     minikube tunnel
 ```

 - Access swagger api endpoint with below url.
 
    http://localhost:8080/swagger-ui/