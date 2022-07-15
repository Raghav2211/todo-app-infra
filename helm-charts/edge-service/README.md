#  Edge Service App Helm Chart


## Introduction

This chart bootstraps a single node Edge Service deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `edge-service`:

To install the chart with the release name `edge-service` with respective environment secret and configuration file:

- Local
```bash
# Verify the configuration 
$ helm install --dry-run --debug edge-service edge-service -f edge-service/env/local/secrets.yaml

# Install chart
$ minikube image load edge-service:${EDGE_SERVICE_VERSION}
$ helm install edge-service edge-service -f edge-service/env/local/secrets.yaml
```

- EKS
```bash
# Verify the configuration 
$ helm install --dry-run --debug --set aws.account=<account> --set aws.region=<region> edge-service edge-service -f edge-service/env/local/secrets.yaml -f edge-service/env/eks/values.yaml

# Install chart
$ helm install --set aws.account=<account> --set aws.region=<region> edge-service edge-service -f edge-service/env/local/secrets.yaml -f edge-service/env/eks/values.yaml
    
```

## Uninstalling the Chart

To uninstall/delete the `edge-service` deployment:

```bash
$ helm uninstall edge-service
```

The command removes all the Kubernetes components associated with the chart and deletes the release completely.

## Configuration

The following table lists the configurable parameters of the Edge Service chart and their default values.

| Parameter                                    | Description                                                                                  | Default                                              |
| -------------------------------------------- | -------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| `replica`                                 | Number of instance to run at any time                                                      	| 1 |
| `image`                                        | `edge-service` image configuration.                                                            	| ` ` |
| `image.repository`                             | `edge-service` image repository.                                                               	| `edge-service`|
| `image.pullPolicy`                             | `edge-service` image pull policy.                                                             	 | `IfNotPresent`|
| `image.tag`                                    | `edge-service` image tag.                                                                      	| `1.0.0`|
| `livenessProbe`                                | Indicates whether the container is running.                                                | ` {}` |
| `service`                                      | Kubernetes service configuration.                                                          | ` ` |
| `service.type`                                 | ServiceTypes allow you to specify what kind of Service you want.                           | `LoadBalancer` |
| `service.port`                                 | Port internal to Kubernetes                                    .                           | 8081 |
| `service.nodeport`                             | NodePort gives you the freedom to set up your own load balancing solution.                 | 30001|
| `resources`                                    | `edge-service` CPU/Memory resource requests/limits                                         | `{}` |
| `edge`                                         | Edge service config                                                                        | `  `  |
| `edge.google`                                  | Edge service google oauth2 configuration                                                   | `  `  |
| `edge.google.clientId`                         | Google oauth2 client id
| `edge.google.clientSecret`                     | Google oauth2 client secret                                                               | `  `  |
| `springProfiles`                               | Spring profile to pick configuration                                                     | ` k8s`  |








