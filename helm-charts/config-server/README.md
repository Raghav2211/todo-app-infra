#  Config Server Helm Chart


## Introduction

This chart bootstraps a single node Config Server deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `config-server`:

To install the chart with the release name `config-server` with respective environment secret and configuration file:

- Local
```bash
# Verify the configuration 
$ helm install --dry-run --debug config-server config-server -f config-server/env/minikube/values.yaml

# Install chart
$ minikube image load config-server:${CONFIG_SERVER_VERSION}
$ helm install config-server config-server -f config-server/env/minikube/values.yaml
```

- EKS
```bash
# Verify the configuration 
$ helm install --dry-run --debug --set aws.account=<account> --set aws.region=<region> config-server config-server -f config-server/env/eks/values.yaml

# Install chart
$ helm install --set aws.account=<account> --set aws.region=<region> config-server config-server -f config-server/env/eks/values.yaml
    
```

## Uninstalling the Chart

To uninstall/delete the `config-server` deployment:

```bash
$ helm uninstall config-server
```

The command removes all the Kubernetes components associated with the chart and deletes the release completely.

## Configuration

The following table lists the configurable parameters of the Config Server chart and their default values.

| Parameter                                    | Description                                                                                  | Default                                              |
| -------------------------------------------- | -------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| `replica`                                 | Number of instance to run at any time                                                      	| 1 |
| `image`                                        | `config-server` image configuration.                                                            	| ` ` |
| `image.repository`                             | `config-server` image repository.                                                               	| `config-server`|
| `image.pullPolicy`                             | `config-server` image pull policy.                                                             	 | `IfNotPresent`|
| `image.tag`                                    | `config-server` image tag.                                                                      	| `1.0.0`|
| `livenessProbe`                                | Indicates whether the container is running.                                                | ` {}` |
| `service`                                      | Kubernetes service configuration.                                                          | ` ` |
| `service.type`                                 | ServiceTypes allow you to specify what kind of Service you want.                           | `LoadBalancer` |
| `service.port`                                 | Port internal to Kubernetes                                    .                           | 8081 |
| `service.nodeport`                             | NodePort gives you the freedom to set up your own load balancing solution.                 | 30001|
| `resources`                                    | `config-server` CPU/Memory resource requests/limits                                         | `{}` |
| `springProfiles`                               | Spring profile to pick configuration                                                     | ` k8s`  |








