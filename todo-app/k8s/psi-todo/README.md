#  Todo App Helm Chart


## Introduction

This chart bootstraps a single node Todo App deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- MySql

## Installing the Chart

To install the chart with the release name `psi-todo`,Execute dry run command for verification , then the command :

```bash
$ helm install --dry-run --debug psi-todo ./psi-todo
$ helm install psi-todo ./psi-todo
```


The above command deploys Todo App on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

To install the chart with the release name `psi-todo` with secrets from secret env file and with overridden default properties,Execute dry run command for verification, then the command:

```bash
$ helm install --dry-run --debug ./psi-todo -f env/<env>/secret.yaml -f env/<env>/values.yaml
$ helm install psi-todo ./psi-todo -f env/<env>/secret.yaml -f env/<env>/values.yaml
```

## Uninstalling the Chart

To uninstall/delete the `psi-todo` deployment:

```bash
$ helm delete --purge psi-todo
```

The command removes all the Kubernetes components associated with the chart and deletes the release completely.

## Configuration

The following table lists the configurable parameters of the PSI-TODO chart and their default values.

| Parameter                                    | Description                                                                                  | Default                                              |
| -------------------------------------------- | -------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| `replicaCount`                                 | Number of instance to run at any time                                                      | 1 |
| `image`                                        | `mysql` image configuration.                                                               | ` ` |
| `image.repository`                             | `mysql` image pull policy.                                                                 | `Never`|
| `image.pullPolicy`                             | `mysql` image repository.                                                                  | `mysql`|
| `image.tag`                                    | `mysql` image tag.                                                                         | `1.0.0`|
