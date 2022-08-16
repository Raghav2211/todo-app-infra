#  Todo App Helm Chart


## Introduction

This chart bootstraps a single node Todo App deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Mongo

## Installing the Chart

To install the chart with the release name `todo`:

- Local
```bash
# Verify the configuration 
$ minikube image load todo:${TODO_APP_VERSION}
$ helm dep update todo
$ helm install --dry-run --debug todo todo

# Install chart
$ helm install todo todo 
```
- EKS
```bash
# Verify the configuration 
$ helm install --dry-run --debug --set aws.account=<account> --set aws.region=<region> todo todo -f todo/env/eks/values.yaml

# Install chart
$ helm install --set aws.account=<account> --set aws.region=<region> todo todo -f todo/env/eks/values.yaml

```

## Uninstalling the Chart

To uninstall/delete the `todo` deployment:

```bash
$ helm uninstall todo
```

The command removes all the Kubernetes components associated with the chart and deletes the release completely.

## Configuration

The following table lists the configurable parameters of the TODO chart and their default values.

| Parameter                                    | Description                                                                                  | Default                                              |
| -------------------------------------------- | -------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| `replica`                                 | Number of instance to run at any time                                                      	| 1 |
| `image`                                        | `todo` image configuration.                                                            	| ` ` |
| `image.repository`                             | `todo` image repository.                                                               	| `todo`|
| `image.pullPolicy`                             | `todo` image pull policy.                                                             	 | `IfNotPresent`|
| `image.tag`                                    | `todo` image tag.                                                                      	| `2.0.0`|
| `livenessProbe`                                | Indicates whether the container is running.                                                | ` {}` |
| `service`                                      | Kubernetes service configuration.                                                          | ` ` |
| `service.type`                                 | ServiceTypes allow you to specify what kind of Service you want.                           | `LoadBalancer` |
| `service.port`                                 | Port internal to Kubernetes                                    .                           | 8080 |
| `service.nodeport`                             | NodePort gives you the freedom to set up your own load balancing solution.                 | 30000|
| `resources`                                    | `todo` CPU/Memory resource requests/limits                                             	| `{}` |
| `springProfiles`                               | Spring profile to pick configuration                                                     | ` k8s`  |











