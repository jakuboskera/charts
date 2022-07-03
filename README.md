<div align="center">
    <h1>Helm charts for Kubernetes</h1>
    <a href="https://github.com/jakuboskera/charts/actions"><img alt="jakuboskera" src="https://img.shields.io/github/workflow/status/jakuboskera/charts/Release%20Charts?label=Release%20charts&logo=github"></a>
    <a href="https://opensource.org/licenses/Apache-2.0"><img alt="jakuboskera" src="https://img.shields.io/badge/License-Apache%202.0-blue.svg"></a>
</div>

Applications developed by [@jakuboskera](https://github.com/jakuboskera) ready to launch on Kubernetes using [Helm](https://helm.sh).

⚠️ Prerequisites
- Helm 3.1.0+

## Usage

```bash
helm repo add jakuboskera https://jakuboskera.github.io/charts
helm search repo jakuboskera
helm install my-release jakuboskera/<chart>
```
