# Deploy Todo Application to K8s cluster using helm

- Local Deployment
- EKS

## Local Deployment ##

- Setup minikube

   Install  Dependencies and run minikube

    ```bash
       bash setup.sh bootlocal  
    ```
- Local KMS
  ```bash
    $ kubectl create -f local-kms.yml
  ```
- [Deploy Config Server](../helm-charts/config-server/README.md#Installing%20the%20Chart)
  
- [Deploy Edge Service](../helm-charts/edge-service/README.md#Installing%20the%20Chart)

- [Deploy Todo-app](../helm-charts/todo/README.md#Installing%20the%20Chart)  

  - Verify all pods are up and running
 
     ```bash
       $ kubectl get pods
        NAME                            READY   STATUS    RESTARTS   AGE
        config-server-58847745b-jkjd5   1/1     Running   0          21m
        edge-service-7777c54494-tl2kj   1/1     Running   0          20m
        kms                             1/1     Running   0          16h
        mongodb-8b4cb7dc-vzz2r          1/1     Running   0          6m15s
        todo-777c54c599-cbnvc           1/1     Running   0          9m40s

     ```

- Execute below command in a separate terminal which creates a route to services deployed with type LoadBalancer and sets their Ingress to their ClusterIP.

   ```bash
       minikube tunnel
   ```

- Access

  http://localhost:8081  # get access_token

  http://localhost:8080/webjars/swagger-ui/index.html # use access_token to access the API(s)


## EKS ##
[Deploy](../aws/v2_0_0.md)