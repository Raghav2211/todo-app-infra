# Deploy Todo Application to K8s cluster using helm

- Local Deployment

## Local Deployment ##

- Setup minikube

   Install  Dependencies and run minikube

    ```bash
       bash setup.sh bootlocal  
    ```
  
- [Deploy Edge Service](../helm-charts/edge-service/README.md#Installing%20the%20Chart)

- [Deploy Todo-app](../helm-charts/todo/README.md#Installing%20the%20Chart)  

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

- Access

  http://localhost:8081  # get access_token

  http://localhost:8080/webjars/swagger-ui/index.html # use access_token to access the API(s)

## EKS ##
```bash
# install nginx ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/aws/deploy.yaml
```
