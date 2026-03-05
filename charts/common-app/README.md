# common-app

Generic Helm chart for deploying applications. Provides a **Deployment**, **Service**, and an optional **ConfigMap** for environment variables.

## Usage

```bash
helm install my-app charts/common-app \
  --set image.repository=my-service \
  --set image.tag=1.0.0
```

## Parameters

### Image

| Parameter | Description | Default |
|---|---|---|
| `image.registry` | Container image registry | `ghcr.io/jakuboskera` |
| `image.repository` | Container image repository | `""` |
| `image.tag` | Container image tag | `""` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |

### Deployment

| Parameter | Description | Default |
|---|---|---|
| `replicaCount` | Number of pod replicas | `1` |
| `resources` | CPU/memory resource requests and limits | `{}` |

### Service

| Parameter | Description | Default |
|---|---|---|
| `service.type` | Kubernetes Service type | `ClusterIP` |
| `service.port` | Port for both Service and container | `8080` |

### Environment variables

| Parameter | Description | Default |
|---|---|---|
| `env` | Key-value pairs injected as environment variables via ConfigMap | `{}` |

When `env` is non-empty, the chart creates a ConfigMap (`<fullname>-env`) and mounts it into the Deployment via `envFrom`. The Deployment is annotated with:

- `checksum/env` — triggers a rolling restart on `helm upgrade` when the ConfigMap content changes
- `reloader.stakater.com/auto: "true"` — enables [Reloader](https://github.com/stakater/Reloader) to watch for live ConfigMap changes

### Example

```yaml
# values.yaml
image:
  repository: my-service
  tag: "2.0.0"

service:
  port: 3000

env:
  DATABASE_URL: "postgres://db:5432/mydb"
  LOG_LEVEL: "info"
```
