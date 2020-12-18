# Deploy Todo Application in K8s cluster using helm

- Local Deployment
- AWS Deployment

## Local Deployment ##

- Setup minikube

   Install  Dependencies and run minikube

    ```bash
     ./setup.sh boot local  
    ```
   
 - Link host docker client to the VM's docker daemon
 
    ```bash
     eval $(minikube docker-env)  
    ```
 - Build
 
    [Build & Create Docker Image](../README.md#build)
 
 - Deploy  mysql
          
    ```bash
       helm install --dry-run --debug mysql ./mysql -f env/<env>/mysql-secret.yaml
       helm install mysql ./mysql -f env/<env>/mysql-secret.yaml
       # or
       # Passing env file to override default properties which is optional
       helm install --dry-run --debug mysql ./mysql -f env/<env>/mysql-secret.yaml -f env/<env>/mysql-values.yaml 
       helm install mysql ./mysql -f env/<env>/mysql-secret.yaml -f env/<env>/mysql-values.yaml 
    ```
    
 - Deploy Todo-app    
 
    ```bash
       helm install --dry-run --debug psi-todo ./psi-todo
       helm install psi-todo ./psi-todo
       # or
       # Passing env file to override default properties which is optional
       helm install --dry-run --debug ./psi-todo -f env/<env>/psi-todo-secret.yaml -f env/<env>/psi-todo-values.yaml
       helm install psi-todo ./psi-todo -f env/<env>/psi-todo-secret.yaml -f env/<env>/psi-todo-values.yaml
    ```  

 - Verify all pods are up and running
 
    ```bash
      $ kubectl get pods
       NAME                         READY   STATUS    RESTARTS   AGE
       psi-todo-6f4f69b7d7-8t8kg    1/1     Running   0          92m
       mysql-58b87bf444-pshmk       1/1     Running   0          92m

    ```

 - Execute below command in a separate terminal which creates a route to services deployed with type LoadBalancer and sets their Ingress to their ClusterIP.

    ```bash
        minikube tunnel
    ```

 - Access swagger api endpoint with below url.
 
    http://localhost:8080/swagger-ui/
