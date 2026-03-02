# TODO Operator

TODO Operator is a showcase of a small Kubernetes operator that can be used to manage the [TODO](https://github.com/jakuboskera/todo) application. It introduces custom resources `Task` and `TodoEndpoint` to your cluster.

## TL;DR

```console
helm repo add jakuboskera https://jakuboskera.github.io/charts
helm install my-release jakuboskera/todo-operator
```

## Introduction

This chart bootstraps a TODO Operator deployment on a Kubernetes cluster using the Helm package manager. The operator watches for `Task` and `TodoEndpoint` custom resources and reconciles them.

## Prerequisites

- Kubernetes 1.20+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release jakuboskera/todo-operator
```

The command deploys TODO Operator on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Note**: CRDs placed in the `crds/` directory are managed by Helm — they are installed automatically during `helm install`, but are **never removed** during `helm uninstall` or `helm upgrade`. This is standard Helm behavior to prevent accidental data loss. To remove them manually after uninstalling:
>
> ```console
> kubectl delete crd tasks.todo.jakuboskera.dev todoendpoints.todo.jakuboskera.dev
> ```

## Custom Resource Definitions

The operator installs the following CRDs:

| CRD | Description |
| --- | --- |
| `tasks.todo.jakuboskera.dev` | Represents a TODO task |
| `todoendpoints.todo.jakuboskera.dev` | Represents a TODO endpoint |

### TodoEndpoint

A `TodoEndpoint` defines a connection to a Todo API instance. It requires a `url` and a reference to a `Secret` containing the API key.

#### In-cluster instance

```yaml
apiVersion: todo.jakuboskera.dev/v1alpha1
kind: TodoEndpoint
metadata:
  name: todo-local
spec:
  url: "http://todo-app.default.svc.cluster.local"
  apiSecretRef:
    name: todo-local-api-secret
    key: api-key
```

#### External instance (on the internet)

```yaml
apiVersion: todo.jakuboskera.dev/v1alpha1
kind: TodoEndpoint
metadata:
  name: todo-external
spec:
  url: "https://todo.example.com"
  apiSecretRef:
    name: todo-external-api-secret
    key: api-key
```

Don't forget to create the referenced Secret:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: todo-external-api-secret
type: Opaque
stringData:
  api-key: "my-super-secret-api-key"
```

### Task

A `Task` represents a single TODO item. It must reference a `TodoEndpoint` via `endpointRef` so the operator knows which API instance to sync the task to.

```yaml
apiVersion: todo.jakuboskera.dev/v1alpha1
kind: Task
metadata:
  name: buy-groceries
spec:
  text: "Buy groceries"
  isDone: false
  endpointRef:
    name: todo-local
```

You can point tasks to different endpoints:

```yaml
apiVersion: todo.jakuboskera.dev/v1alpha1
kind: Task
metadata:
  name: deploy-production
spec:
  text: "Deploy to production"
  isDone: false
  endpointRef:
    name: todo-external
```

## Architecture

```
                                ┌──────────────────┐
                                │                  │
                                │  TODO Operator   │
                                │                  │
                                └───────┬──────────┘
                                        │ watches & reconciles
                        ┌───────────────┼───────────────┐
                        ▼                               ▼
               ┌─────────────────┐             ┌────────────────────┐
               │  Task (CR)      │             │  TodoEndpoint (CR) │
               └─────────────────┘             └────────────────────┘
```

## Parameters

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.
