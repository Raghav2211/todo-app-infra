# Setting up kubernetes cluster in local using minikube

- Install and run minikube

  Use following instructions to install minikube
  
    https://minikube.sigs.k8s.io/docs/start/
## Running application
 - Use Own Local Docker Images With Minikube
 
 ```bash
    eval $(minikube docker-env)
 ```
 - Build your docker image
 
 ```bash
    docker build -f ./Dockerfile.mvn --tag klab-spring-mysql:0.0.1 .
 ```
 
 - Start local todo cluster
 
 ```bash
    cd <app-path>/local-kube-env
    kubectl apply -f ./
 ```

 - Verify all pods are up and running
 
 ```bash
    kubectl get pods
 ```

 - Execute below command in a separate terminal which creates a route to services deployed with type LoadBalancer and sets their Ingress to their ClusterIP.

 ```bash
     minikube tunnel
 ```

 - Access todo swagger api endpoint in browser with below url.
 
    http://localhost:8080/swagger-ui/