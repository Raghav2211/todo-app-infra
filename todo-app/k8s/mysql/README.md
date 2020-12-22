#  MySql Helm Chart


## Introduction

This chart bootstraps a single node MySQL deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19.2
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `mysql` with secrets from secret env file,Execute dry run command for verification , then the command :

```bash
$ helm install --dry-run --debug --name mysql ./mysql -f ./mysql/env/<env>/secret.yaml
$ helm install --name mysql ./mysql -f ./mysql/env/<env>/secret.yaml
```

The above command deploys MySQL on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

To install the chart with the release name `mysql` with secrets from secret env file and with overridden default properties,Execute dry run command for verification, then the command:

```bash
$ helm install --dry-run --debug --name mysql ./mysql -f ./mysql/env/<env>/secret.yaml -f env/<env>/values.yaml
$ helm install --name mysql ./mysql -f ./myslq/env/<env>/secret.yaml -f ./mysql/env/<env>/values.yaml
```

## Uninstalling the Chart

To uninstall/delete the `mysql` deployment:

```bash
$ helm delete --purge mysql
```

The command removes all the Kubernetes components associated with the chart and deletes the release completely.

## Configuration

The following table lists the configurable parameters of the MySQL chart and their default values.

| Parameter                                    | Description                                                                                  | Default                                              |
| -------------------------------------------- | -------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| `replicaCount`                                 | Number of instance to run at any time                                                   | 1                                              |
| `image`                                          | `mysql` image configuration.                                                          | ` `                                             |
| `image.repository`                            | `mysql` image repository.                                                             | `mysql`                                    |
| `image.tag`                                     | `mysql` image tag.                                                                    | `8.0.22`                                                |
| `service`                                        | `mysql` service configuration                                                         | ` `
| 
| `service.type`                               | Kubernetes service type                                                                      | ClusterIP                                            |
| `service.port`                     | Service Port to be exposed outside                                                                      | 3306                                                 |
| `resources`                     | `mysql` CPU/Memory resource requests/limits                                                                    | `{}`                                                 |
| `resources.limits`                     | `mysql` resource limits                                                                    | ` `                                                 | 
| `resources.limits.cpu`                     | `mysql` CPU resource limits                                                                    | ` `                                                 |
| `resources.limits.memory`                     | `mysql` Memory resource limits                                                                    | ` `                                                 |
| `resources.requests`                         | `mysql` resource request configuration                                                                    | ` `                                                 |
| `resources.requests.cpu`                    | `mysql` CPU resource request configuration                                                                    | ` `                                                 |
| `resources.requests.memory`                | `mysql` memory resource request configuration                                                                    | ` `                                                 |
| `persistence`                                  | persistence is to recover data after pod kill                                                                    | `{}`                                                 |
| `persistence.local`                          | persistence for local enabled or not                                                                    | ` `                                                 |
| `persistence.storageClass`                 | Type of persistent volume claim                                                                    | ` `                                                 |
| `persistence.accessMode`                 | ReadWriteOnce or ReadOnly                                                                   | ` `                                                 |
| `persistence.size`                 | Size of persistent volume claim                                                                  | ` `                                                 |
| `persistence.hostPath`                 | HostPath of the volume to mount                                                                  | ` `                                                 |
| `mysqlConfig`                 | Configuration for mysql                                                                  | ` `                                                 |
| `mysqlConfig.database`     |  database name                                                                 | `psi`                                                 |
| `mysqlUsername`     |  database user name                                                                 | ` `                                                 |
| `mysqlPassword`     |  database password                                                                 | ` `                                                 |
| `affinityNodes`     | affinityNodes is the nodes list in which pod will deploy                                                                 | `[]`                                                 |
## Persistence

Persistence configuration stores the MySQL data and configurations at the `/var/lib/mysql` path of the container.

PersistentVolume will be created for local if `persistence.local` is set to true and if true then data will be  mounted into specified directory. In order to disable this functionality `persistence.local` should be set as false.