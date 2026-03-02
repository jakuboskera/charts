# todo

[todo](https://github.com/jakuboskera/todo) is a simple cloud-native TODO web application with API and Swagger documentation.

## TL;DR

```console
$ helm repo add jakuboskera https://jakuboskera.github.io/charts
$ helm install my-release jakuboskera/todo
```

## Introduction

This chart bootstraps a [todo](https://github.com/jakuboskera/todo) application on a Kubernetes cluster using the Helm package manager. It optionally supports deploying [todo-operator](https://github.com/jakuboskera/charts/tree/main/charts/todo-operator) for managing TODO tasks via Kubernetes custom resources.

## Prerequisites

- Kubernetes 1.20+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release jakuboskera/todo
```

The command deploys todo on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation. These parameters were automatically generated using [`readme-generator-for-helm`](https://github.com/bitnami-labs/readme-generator-for-helm).

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
Users ────────►│  todo       ├─────────────►│  PostgreSQL   │
               │             │              │               │
               └─────────────┘              └───────────────┘
```

### Todo Operator integration

This chart has optional integration with [todo-operator](https://github.com/jakuboskera/charts/tree/main/charts/todo-operator), a Kubernetes operator that manages TODO tasks via custom resources (`TodoEndpoint`, `Task`).

There are two ways to use it:

#### Option A: Deploy the operator together with the todo app

Set `operator.enabled: true` to install the `todo-operator` as a subchart. CRDs are installed automatically from the subchart's `crds/` directory.

```yaml
operator:
  enabled: true

todoOperatorIntegration:
  enabled: true
  tasks:
    - name: first-task
      text: "Finish implementation"
      isDone: false
    - name: second-task
      text: "Write documentation"
      isDone: true
```

#### Option B: Use a pre-installed operator

If `todo-operator` (and its CRDs) are already installed in the cluster (e.g. via a standalone `todo-operator` chart), you can just enable the integration without deploying the operator again:

```yaml
operator:
  enabled: false

todoOperatorIntegration:
  enabled: true
  tasks:
    - name: my-task
      text: "Buy groceries"
      isDone: false
```

#### What happens when the operator is not installed?

If `todoOperatorIntegration.enabled: true` but the CRDs are **not present** in the cluster, the `TodoEndpoint` and `Task` resources are **silently skipped** — the chart won't fail. This means you can safely define tasks in your values even when the operator is not (yet) deployed.

#### What gets created?

When operator integration is enabled and CRDs are available, the chart creates:

1. **A `TodoEndpoint`** — automatically configured to point to this todo instance's in-cluster Service URL and the Secret containing the API key.
2. **`Task` resources** — one for each entry in `todoOperatorIntegration.tasks`, all referencing the auto-created `TodoEndpoint`.

## Parameters

### Global parameters

| Name                                         | Description                                                                | Value   |
| -------------------------------------------- | -------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                       | Global Docker image registry                                               | `""`    |
| `global.imagePullSecrets`                    | Global Docker registry secret names as an array                            | `[]`    |
| `global.storageClass`                        | Global StorageClass for Persistent Volume(s)                               | `""`    |
| `global.postgresql.auth.postgresPassword`    | Password for the "postgres" admin user (overrides `auth.postgresPassword`) | `admin` |
| `global.postgresql.auth.username`            | Name for a custom user to create (overrides `auth.username`)               | `todo`  |
| `global.postgresql.auth.password`            | Password for the custom user to create (overrides `auth.password`)         | `todo`  |
| `global.postgresql.auth.database`            | Name for a custom database to create (overrides `auth.database`)           | `todo`  |
| `global.postgresql.service.ports.postgresql` | PostgreSQL service port (overrides `service.ports.postgresql`)             | `5432`  |


### PostgreSQL parameters

| Name                 | Description                                                | Value   |
| -------------------- | ---------------------------------------------------------- | ------- |
| `postgresql.enabled` | Install PostgreSQL subchart. Only needed when config=prod. | `false` |


### Common parameters

| Name                | Description                                                                                              | Value           |
| ------------------- | -------------------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                                     | `""`            |
| `nameOverride`      | String to partially override todo.fullname template with a string (will prepend the release name)        | `""`            |
| `fullnameOverride`  | String to fully override todo.fullname template with a string                                            | `""`            |
| `commonAnnotations` | Common annotations to add to all todo resources (sub-charts are not considered). Evaluated as a template | `{}`            |
| `commonLabels`      | Common labels to add to all todo resources (sub-charts are not considered). Evaluated as a template      | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain                                                                                | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release (evaluated as a template).                             | `[]`            |


### todo parameters

| Name                    | Description                                                                           | Value              |
| ----------------------- | ------------------------------------------------------------------------------------- | ------------------ |
| `apiKey`                | API key used to authenticate requests to the todo API. Stored in a Secret as API_KEY. | `12345678`         |
| `config`                | Application configuration profile.                                                    | `dev`              |
| `image.registry`        | todo image registry                                                                   | `docker.io`        |
| `image.repository`      | todo image repository                                                                 | `jakuboskera/todo` |
| `image.tag`             | todo image tag (immutable tags are recommended)                                       | `v0.2.3`           |
| `image.pullPolicy`      | todo image pull policy                                                                | `IfNotPresent`     |
| `image.pullSecrets`     | Specify image pull secrets                                                            | `[]`               |
| `resources.requests`    | The requested resources for the container                                             | `{}`               |
| `networkPolicy.enabled` | Enable creation of NetworkPolicy resources. Only Ingress traffic is filtered for now. | `false`            |


### Traffic exposure parameters

| Name                     | Description                                                                                                                      | Value                    |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`           | Kubernetes Service type                                                                                                          | `ClusterIP`              |
| `service.port`           | todo service port                                                                                                                | `80`                     |
| `service.nodePort`       | Specify the nodePort value for the LoadBalancer and NodePort service types                                                       | `""`                     |
| `service.loadBalancerIP` | loadBalancerIP if todo service type is `LoadBalancer` (optional, cloud specific)                                                 | `""`                     |
| `service.annotations`    | Provide any additional annotations which may be required.                                                                        | `{}`                     |
| `ingress.enabled`        | Set to true to enable ingress record generation                                                                                  | `false`                  |
| `ingress.pathType`       | Ingress Path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`     | Override API Version (automatically detected if not set)                                                                         | `""`                     |
| `ingress.hostname`       | When the ingress is enabled, a host pointing to this will be created                                                             | `todo.local`             |
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
| `dbReadiness.image.tag`          | Init container dbReadiness image tag                 | `1.37.0`          |
| `dbReadiness.image.pullPolicy`   | Init container dbReadiness image pull policy         | `IfNotPresent`    |
| `dbReadiness.image.pullSecrets`  | Init container volume-permissions image pull secrets | `[]`              |
| `dbReadiness.resources.limits`   | The resources limits for the container               | `{}`              |
| `dbReadiness.resources.requests` | The requested resources for the container            | `{}`              |


### Todo Operator parameters

| Name               | Description                    | Value   |
| ------------------ | ------------------------------ | ------- |
| `operator.enabled` | Install todo-operator subchart | `false` |


### Todo Operator integration parameters

| Name                              | Description                                                     | Value  |
| --------------------------------- | --------------------------------------------------------------- | ------ |
| `todoOperatorIntegration.enabled` | Enable TodoEndpoint and Task custom resources for this instance | `true` |
| `todoOperatorIntegration.tasks`   | List of tasks to create for THIS todo instance                  | `[]`   |


## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.
