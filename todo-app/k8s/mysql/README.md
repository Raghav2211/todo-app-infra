#  MySql Helm Chart


## Introduction

This chart bootstraps a single node MySQL deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19.2
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `mysql` with secrets from secret env file,Execute dry run command for verification , then the command :

```bash
$ helm install --dry-run --debug --name mysql ./mysql -f env/<env>/mysql-secret.yaml
$ helm install --name mysql ./mysql -f env/<env>/mysql-secret.yaml
```

The above command deploys MySQL on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

To install the chart with the release name `mysql` with secrets from secret env file and with overridden default properties,Execute dry run command for verification, then the command:

```bash
$ helm install --dry-run --debug --name mysql ./mysql -f env/<env>/mysql-secret.yaml -f env/<env>/mysql-values.yaml
$ helm install --name mysql ./mysql -f env/<env>/mysql-secret.yaml -f env/<env>/mysql-values.yaml
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
| `image.repository`                                      | `mysql` image repository.                                                                    | `mysql`                                              |
| `image.tag`                                   | `mysql` image tag.                                                                           | `8.0.22`                                             |
| `image.pullPolicy`                            | Image pull policy                                                                            | `IfNotPresent`                                       |
| `mysqlConfig.mysqlUser`                                  | Username of new user to create.                                                              | `nil`                                                |
| `mysqlConfig.mysqlPassword`                              | Password for the new user. Ignored if existing secret is provided                            | Random 10 characters                                 |
| `mysqlConfig.database`                              | Name for new database to create.                                                             | `psi`                                                |
| `persistence`                        | persistence is to recover data after pod kill                                                                | `nil`                                                |
| `persistence.size`                           | Size of persistent volume claim                                                              | 8Gi RW                                               |
| `persistence.storageClass`                   | Type of persistent volume claim                                                              | nil                                                  |
| `persistence.accessMode`                     | ReadWriteOnce or ReadOnly                                                                    | ReadWriteOnce                                        |
| `persistence.existingClaim`                  | Name of existing persistent volume                                                           | `nil`                                                |
| `persistence.hostPath`                        | Subdirectory of the volume to mount                                                          | `nil`                                                |
| `nodeSelector`                               | Node labels for pod assignment                                                               | {}                                                   |
| `affinityNodes`                                   | affinityNodes is the nodes list in which pod will deploy                                                            | `[]`                                                   |
| `service.type`                               | Kubernetes service type                                                                      | ClusterIP                                            |
| `service.port`                     | Service Port to be exposed outside                                                                      | 3306                                                 |

## Persistence

The [MySQL](https://hub.docker.com/_/mysql/) image stores the MySQL data and configurations at the `/var/lib/mysql` path of the container.

By default a PersistentVolumeClaim is created and mounted into that directory. In order to disable this functionality
you can change the values.yaml to disable persistence and use an emptyDir instead.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*
1.19.2
