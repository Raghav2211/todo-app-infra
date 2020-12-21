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
| `image.repository`                                      | `psi-todo` image repository.                                                                    | `psi-todo`                                              |
| `image.tag`                                   | `mysql` image tag.                                                                           | `1.0.0`                                             |
| `image.pullPolicy`                                   | `mysql` image tag.                                                                           | `Never`                                             |
| `livenessProbe.enabled`                     | Liveness probe enabled                                                                      | `true`                                                   |
| `livenessProbe.initialDelaySeconds`          | Delay before liveness probe is initiated                                                     | 60                                                   |
| `livenessProbe.periodSeconds`                | How often to perform the probe                                                               | 30                                                   |
| `livenessProbe.timeoutSeconds`               | When the probe times out                                                                     | 10                                                    |
| `livenessProbe.successThreshold`             | Minimum consecutive successes for the probe to be considered successful after having failed. | 1                                                    |
| `livenessProbe.failureThreshold`             | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | 3                                                    |
| `initContainer.dbWait`                              |dbWait until mysql is not up                                                      | `nil`                                                |
| `initContainer.dbWait.image`                        | image for dbwait                                                                  | busybox                                                |
| `initContainer.dbWait.tag`                        | image tag for dbwait                                                                | latest                                                 |
| `initContainer.dbWait.imagePullPolicy`        | image tag for dbwait pull policy                                                             | IfNotPresent                                              |
| `resources`                                  | CPU/Memory resource requests/limits                                                          | ``                         |
| `security.basicAuth.username`                    | Spring security                                                           | ``                                              |
| `security.basicAuth.password`                    | Spring security                                                      | ``                                                  |