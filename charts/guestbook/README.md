# Guestbook

Guestbook is a simple cloud-native web application which allows visitors to leave a public comment without creating a user account.
## TL;DR

```console
$ helm repo add jakuboskera https://jakuboskera.github.io/charts
$ helm install my-release jakuboskera/guestbook
```

## Introduction

This chart bootstrap a Guestbook application on a Kubernetes cluster using the Helm package manager.

## Prerequisites

- Kubernetes 1.20+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release jakuboskera/guestbook
```

The command deploys Guestbook on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation. These parameters were automatically generated using [`readme-generator-for-helm`](https://github.com/bitnami-labs/readme-generator-for-helm).

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


## Architecture

Diagram was generated using **[asciiflow](https://asciiflow.com/#/)**.

```
               ┌─────────────┐              ┌───────────────┐
         80/TCP│             │      5432/TCP│               │
Users ────────►│  Guestbook  ├─────────────►│  PostgreSQL   │
               │             │              │               │
               └─────────────┘              └───────────────┘
```

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                | Description                                                                                                   | Value           |
| ------------------- | ------------------------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                                          | `""`            |
| `nameOverride`      | String to partially override guestbook.fullname template with a string (will prepend the release name)        | `""`            |
| `fullnameOverride`  | String to fully override guestbook.fullname template with a string                                            | `""`            |
| `commonAnnotations` | Common annotations to add to all Guestbook resources (sub-charts are not considered). Evaluated as a template | `{}`            |
| `commonLabels`      | Common labels to add to all Guestbook resources (sub-charts are not considered). Evaluated as a template      | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain                                                                                     | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release (evaluated as a template).                                  | `[]`            |


### Guestbook parameters

| Name                                 | Description                                                                           | Value                   |
| ------------------------------------ | ------------------------------------------------------------------------------------- | ----------------------- |
| `image.registry`                     | Guestbook image registry                                                              | `docker.io`             |
| `image.repository`                   | Guestbook image repository                                                            | `jakuboskera/guestbook` |
| `image.tag`                          | Guestbook image tag (immutable tags are recommended)                                  | `v0.2.1`                |
| `image.pullPolicy`                   | Guestbook image pull policy                                                           | `IfNotPresent`          |
| `image.pullSecrets`                  | Specify image pull secrets                                                            | `[]`                    |
| `resources.requests`                 | The requested resources for the container                                             | `{}`                    |
| `networkPolicy.enabled`              | Enable creation of NetworkPolicy resources. Only Ingress traffic is filtered for now. | `false`                 |
| `livenessProbe.enabled`              | Enable/disable the liveness probe                                                     | `true`                  |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                              | `60`                    |
| `livenessProbe.periodSeconds`        | How often to perform the probe                                                        | `10`                    |
| `livenessProbe.timeoutSeconds`       | When the probe times out                                                              | `5`                     |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures to be considered failed                                  | `6`                     |
| `livenessProbe.successThreshold`     | Minimum consecutive successes to be considered successful                             | `1`                     |
| `readinessProbe.enabled`             | Enable/disable the readiness probe                                                    | `true`                  |
| `readinessProbe.initialDelaySeconds` | Delay before readinessProbe is initiated                                              | `30`                    |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                     | `10`                    |
| `readinessProbe.timeoutSeconds`      | When the probe times out                                                              | `5`                     |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures to be considered failed                                  | `6`                     |
| `readinessProbe.successThreshold`    | Minimum consecutive successes to be considered successful                             | `1`                     |


### Traffic exposure parameters

| Name                     | Description                                                                                                                      | Value                    |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`           | Kubernetes Service type                                                                                                          | `ClusterIP`              |
| `service.port`           | Guestbook service port                                                                                                           | `80`                     |
| `service.nodePort`       | Specify the nodePort value for the LoadBalancer and NodePort service types                                                       | `""`                     |
| `service.loadBalancerIP` | loadBalancerIP if Guestbook service type is `LoadBalancer` (optional, cloud specific)                                            | `""`                     |
| `service.annotations`    | Provide any additional annotations which may be required.                                                                        | `{}`                     |
| `ingress.enabled`        | Set to true to enable ingress record generation                                                                                  | `false`                  |
| `ingress.pathType`       | Ingress Path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`     | Override API Version (automatically detected if not set)                                                                         | `""`                     |
| `ingress.hostname`       | When the ingress is enabled, a host pointing to this will be created                                                             | `guestbook.local`        |
| `ingress.path`           | The Path to Dokuwiki. You may need to set this to '/*' in order to use this                                                      | `/`                      |
| `ingress.annotations`    | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`            | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                  | `false`                  |
| `ingress.extraHosts`     | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`     | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`       | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`        | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |


### Init container dbReadiness parameters

| Name                             | Description                                          | Value             |
| -------------------------------- | ---------------------------------------------------- | ----------------- |
| `dbReadiness.image.registry`     | Init container dbReadiness image registry            | `docker.io`       |
| `dbReadiness.image.repository`   | Init container dbReadiness image repository          | `library/busybox` |
| `dbReadiness.image.tag`          | Init container dbReadiness image tag                 | `1.33.1`          |
| `dbReadiness.image.pullPolicy`   | Init container dbReadiness image pull policy         | `IfNotPresent`    |
| `dbReadiness.image.pullSecrets`  | Init container volume-permissions image pull secrets | `[]`              |
| `dbReadiness.resources.limits`   | The resources limits for the container               | `{}`              |
| `dbReadiness.resources.requests` | The requested resources for the container            | `{}`              |


### PostgreSQL Parameters

| Name                            | Description                                                                                                                    | Value                            |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | -------------------------------- |
| `postgresql.enabled`            | Deploy the PostgreSQL sub-chart                                                                                                | `true`                           |
| `postgresql.usePasswordFile`    | Mount the PostgreSQL secret as a file                                                                                          | `false`                          |
| `postgresql.external.host`      | Host of an external PostgreSQL installation                                                                                    | `""`                             |
| `postgresql.external.user`      | Username of the external PostgreSQL installation                                                                               | `""`                             |
| `postgresql.external.password`  | Password of the external PostgreSQL installation                                                                               | `""`                             |
| `postgresql.existingSecret`     | Use an existing secret file with the PostgreSQL password (can be used with the bundled chart or with an existing installation) | `{{ .Release.Name }}-postgresql` |
| `postgresql.postgresqlDatabase` | Database name to be used by Guestbook                                                                                          | `guestbook`                      |
| `postgresql.postgresqlUsername` | Username to be created by the PostgreSQL bundled chart                                                                         | `guestbook`                      |


### Metrics parameters

| Name                                      | Description                                                                                 | Value      |
| ----------------------------------------- | ------------------------------------------------------------------------------------------- | ---------- |
| `metrics.enabled`                         | Enable the export of Prometheus metrics                                                     | `false`    |
| `metrics.service.annotations`             | Annotations for Prometheus metrics service                                                  | `{}`       |
| `metrics.serviceMonitor.enabled`          | If the operator is installed in your cluster, set to true to create a Service Monitor Entry | `false`    |
| `metrics.serviceMonitor.namespace`        | Namespace which Prometheus is running in                                                    | `""`       |
| `metrics.serviceMonitor.path`             | HTTP path to scrape for metrics                                                             | `/metrics` |
| `metrics.serviceMonitor.interval`         | Interval at which metrics should be scraped                                                 | `30s`      |
| `metrics.serviceMonitor.scrapeTimeout`    | Specify the timeout after which the scrape is ended                                         | `""`       |
| `metrics.serviceMonitor.relabellings`     | Specify Metric Relabellings to add to the scrape endpoint                                   | `[]`       |
| `metrics.serviceMonitor.honorLabels`      | Specify honorLabels parameter to add the scrape endpoint                                    | `false`    |
| `metrics.serviceMonitor.additionalLabels` | Used to pass Labels that are required by the installed Prometheus Operator                  | `{}`       |


## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.
