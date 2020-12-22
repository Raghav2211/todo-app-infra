#  MySql Helm Chart


## Introduction

This chart bootstraps a single node MySQL deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19.2
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `mysql` with respective environment secret file:

```bash
# Verify the configuration 
$ helm install --dry-run mysql mysql -f mysql/env/<env>/secret.yaml

# Install chart
$ helm install mysql mysql -f mysql/env/<env>/secret.yaml
```

To install the chart with the release name `mysql` with respective environment secret and configuration file:

```bash
# Verify the configuration 
$ helm install --dry-run mysql mysql -f mysql/env/<env>/secret.yaml -f mysql/env/<env>/values.yaml

# Install chart
$ helm install mysql mysql -f myslq/env/<env>/secret.yaml -f mysql/env/<env>/values.yaml
```

## Uninstalling the Chart

To uninstall/delete the `mysql` deployment:

```bash
$ helm delete --purge mysql
```

## Configuration

The following table lists the configurable parameters of the MySQL chart and their default values.

| Parameter                                    | Description                                                                                  | Default                                              |
| -------------------------------------------- | -------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| `replicaCount`                                 | Number of instance to run at any time                                                      | 1 |
| `image`                                        | `mysql` image configuration.                                                               | ` ` |
| `image.repository`                             | `mysql` image repository.                                                                  | `mysql`|
| `image.pullPolicy`                             | `mysql` image pull policy.                                                                 | `IfNotPresent`|
| `image.tag`                                    | `mysql` image tag.                                                                         | `8.0.22`|
| `service`                                      | `mysql` service configuration                                                              | ` ` |
| `service.type`                                 | Kubernetes service type                                                                    | `ClusterIP`|
| `service.port`                                 | Service Port to be exposed outside                                                         | 3306 |
| `resources`                                    | `mysql` CPU/Memory resource requests/limits                                                | `{}` |
| `resources.limits`                             | `mysql` resource limits                                                                    | ` `  |
| `resources.limits.cpu`                         | `mysql` CPU resource limits                                                                | ` `  |
| `resources.limits.memory`                      | `mysql` Memory resource limits                                                             | ` `  |
| `resources.requests`                           | `mysql` resource request configuration                                                     | ` `  |
| `resources.requests.cpu`                       | `mysql` CPU resource request configuration                                                 | ` `  |
| `resources.requests.memory`                    | `mysql` memory resource request configuration                                              | ` `  |
| `persistence`                                  | persistence is to recover data after pod kill                                              | `{}` |
| `persistence.enabled`                          | persistence for enabled or not                                                             | ` `  |
| `persistence.local`                            | persistence for local enabled or not                                                       | ` `  |
| `persistence.storageClass`                     | Type of persistent volume claim                                                            | ` `  |
| `persistence.accessMode`                       | ReadWriteOnce or ReadOnly                                                                  | ` `  |
| `persistence.size`                             | Size of persistent volume claim                                                            | ` `  |
| `persistence.hostPath`                         | HostPath of the volume to mount                                                            | ` `  |
| `config`                                      | Configuration for mysql                                                                    | `{ database: psi }`  |
| `config.database`                              |  Database name                                                                             | `psi`|
| `username`                                     |  Database user name                                                                        | ` `  |
| `password`                                     |  Database password                                                                         | ` `  |
| `affinityNodes`                                | affinityNodes is the nodes list in which pod will deploy                                   | `[]` |



## Persistence

Persistence configuration stores the MySQL data and configurations at the `/var/lib/mysql` path of the container.

PersistentVolume will be created if `persistence.enabled` is set to `true` and if true then data will be  mounted into specified directory. In order to disable this functionality `persistence.enabled` should be set to `false`.
