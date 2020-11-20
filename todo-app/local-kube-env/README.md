# Deploy Todo Application in Local kubernetes cluster

- Setup minikube  
    https://minikube.sigs.k8s.io/docs/start/    

 - Link host docker client to the VM's docker daemon
 
 ```bash
    eval $(minikube docker-env)
 ```
 - Build
 
    [Build & Create Docker Image](../README.md#build)
 
 - Deploy to local cluster
 
 ```bash
    kubectl apply -f .
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