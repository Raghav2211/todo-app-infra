# Deploy Todo Application to K8s cluster using helm

- Local Deployment

## Local Deployment ##

- Setup minikube

   Install  Dependencies and run minikube

    ```bash
       bash setup.sh bootlocal  
    ```
   
- Link host docker client to the VM's docker daemon
 
   ```bash
      eval $(minikube docker-env)  
   ```
 
- Deploy  mongodb
          
   ```bash
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm install my-release bitnami/mongodb
-  ```
    
- Deploy Todo-app    
 
   [Deploy Todo App  using helm](todo/README.md#Installing%20the%20Chart)

- Verify all pods are up and running
 
   ```bash
     $ kubectl get pods
      NAME                         READY   STATUS    RESTARTS   AGE
      todo-6f4f69b7d7-8t8kg        1/1     Running   0          92m
      mysql-58b87bf444-pshmk       1/1     Running   0          92m

   ```

- Execute below command in a separate terminal which creates a route to services deployed with type LoadBalancer and sets their Ingress to their ClusterIP.

   ```bash
       minikube tunnel
   ```

- Access swagger api endpoint with below url.
 
   http://localhost:8080/swagger-ui/
