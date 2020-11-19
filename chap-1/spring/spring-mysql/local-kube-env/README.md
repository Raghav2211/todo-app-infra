# Setting up kubernetes cluster in local using minikube

- Install docker
 
   Use following instructions to install docker
        
    https://docs.docker.com/v17.09/
   
- Install minikube

  Use following instructions to install minikube
  
    https://minikube.sigs.k8s.io/docs/start/
    
- Start Minikube and verify

    ```bash
        minikube start — vm-driver=”hyperv” — hyperv-virtual-switch=”minikube” — v=7 — alsologtostderr
    ```
    
    ```bash
        kubectl config use-context minikube
        kubectl get pods
        kubectl get nodes
    ```
### TODO