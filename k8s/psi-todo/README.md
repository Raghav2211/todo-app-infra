#  Todo App Helm Chart


## Introduction

This chart bootstraps a single node Todo App deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- MySql

## Installing the Chart

To install the chart with the release name `psi-todo`:

```bash
# Verify the configuration 
$ helm install --dry-run --debug psi-todo psi-todo

# Install chart
$ helm install psi-todo psi-todo
```

To install the chart with the release name `psi-todo` with respective environment secret and configuration file:

```bash
# Verify the configuration 
$ helm install --dry-run --debug psi-todo psi-todo -f psi-todo/env/<env>/secrets.yaml -f psi-todo/env/<env>/values.yaml

# Install chart
$ helm install psi-todo psi-todo -f psi-todo/env/<env>/secrets.yaml -f psi-todo/env/<env>/values.yaml
```

## Uninstalling the Chart

To uninstall/delete the `psi-todo` deployment:

```bash
$ helm uninstall psi-todo
```

The command removes all the Kubernetes components associated with the chart and deletes the release completely.

## Configuration

The following table lists the configurable parameters of the PSI-TODO chart and their default values.

| Parameter                                    | Description                                                                                  | Default                                              |
| -------------------------------------------- | -------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| `replica`                                 | Number of instance to run at any time                                                      | 1 |
| `image`                                        | `psi-todo` image configuration.                                                            | ` ` |
| `image.repository`                             | `psi-todo` image repository.                                                               | `psi-todo`|
| `image.pullPolicy`                             | `psi-todo` image pull policy.                                                              | `Never`|
| `image.tag`                                    | `psi-todo` image tag.                                                                      | `1.0.0`|
| `livenessProbe`                                | Indicates whether the container is running.                                                | ` {}` |
| `service`                                      | Kubernetes service configuration.                                                          | ` ` |
| `service.type`                                 | ServiceTypes allow you to specify what kind of Service you want.                           | `LoadBalancer` |
| `service.port`                                 | Port internal to Kubernetes                                    .                           | 8080 |
| `service.nodeport`                             | NodePort gives you the freedom to set up your own load balancing solution.                 | 30000|
| `mysqlRef`                                     | mysqlRef is for inject secret & config of mysql.                                           | "" |
| `mysqlRef`                                     | mysqlRef is for inject secret & config of mysql.                                           | "" |
| `resources`                                    | `psi-todo` CPU/Memory resource requests/limits                                             | `{}` |
| `initContainers`                               | Init containers can contain utilities or setup scripts not present in an app image         | ` `  |
| `initContainers.dbWait`                        | dbWait until mysql is not up                                                               | ` `  |
| `initContainers.dbWait.image`                  | image for running init container                                                           | `busybox `  |
| `initContainers.dbWait.tag`                    | image tag for running init container                                                       | `latest `  |
| `initContainers.dbWait.imagePullPolicy`        | image pull policy for running init container                                               | `IfNotPresent `  |
| `security`                                     | Spring security                                                                            | `  `  |
| `security.basicAuth`                           | Spring security of type basicauth                                                          | `  `  |
| `security.basicAuth.username`                  | Spring security of type basicauth username                                                 | `  `  |
| `security.basicAuth.password`                  | Spring security of type basicauth password                                                 | `  `  |
| `config`                                   | Config for todoApp                                                                         | `  `  |
| `config.securityBasicAuthEnable`           | Enable/ Disable basic-auth                                                                 |`false`|








