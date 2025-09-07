# Rancher Airgap Guide

### Welcome to the Rancher Airgap Guide

Rancher Airgap is a framework and guide built for collecting, packaging, and distributing the Rancher Product Stack for deployment in disconnected or airgapped environments.

We utilize Project [Hauler](https://github.com/hauler-dev/hauler) by [Rancher Government](https://github.com/rancherfederal) to collect, package, and distribute the assets. `Hauler` simplifies the airgap process, by representing assets as content and collections and allows users to easily fetch, store, package, and distribute with declarative manifests or the command line. In this repositry, we generate these manifests for each of the products.

**Review the high level *[example use cases](examples)*!**

**High Level Workflow:**

```bash
Collection -> Across the Airgap -> Distribution
```

**Detailed Workflow:**

```bash
fetch -> validate -> save -> | <airgap> | -> load -> validate -> distribute
```

## Repository Structure

### Core Components

- [hauler/rke2](hauler/rke2/README.md) - provides the content manifest for Rancher Kubernetes (RKE2)
  - currently supports: `RKE2: v1.32.8`
- [hauler/k3s](hauler/k3s/README.md) - provides the content manifest for Rancher K3S (K3S)
  - currently supports: `K3S: v1.32.8`
- [hauler/rancher](hauler/rancher/README.md) - provides the content manifest for Rancher Multi-Cluster Manager
  - currently supports: `Rancher: v2.12.1`
- [hauler/rancher](hauler/rancher/README.md) - provides the content manifest for Cert-Manager
  - currently supports: `Cert-Manager: v1.18.2`
- [hauler/longhorn](hauler/longhorn/README.md) - provides the content manifest for Rancher Longhorn
  - currently supports: `Longhorn: v1.9.1`
- [hauler/neuvector](hauler/neuvector/README.md) - provides the content manifest for Rancher NeuVector
  - currently supports: `NeuVector: v5.4.6`
- [hauler/harvester](hauler/harvester/README.md) - provides the content manifest for Rancher Harvester
  - currently supports: `Harvester: v1.5.1`

### Featured Addons

- [hauler/hauler](hauler/hauler/README.md) - provides the content manifest for Hauler
  - currently supports: `Hauler: v1.2.5`
- [hauler/helm](hauler/helm/README.md) - provides the content manifest for Helm
  - currently supports: `Helm: v3.18.6`
- [hauler/cosign](hauler/cosign/README.md) - provides the content manifest for Cosign
  - currently supports: `Cosign: v2.5.3`
- [hauler/gitea](hauler/gitea/README.md) - provides the content manifest for Gitea
  - currently supports: `Gitea: v1.24.5`
- [hauler/vault](hauler/vault/README.md) - provides the content manifest for Vault
  - currently supports: `Vault: v1.20.1`
- [hauler/kubevip](hauler/kubevip/README.md) - provides the content manifest for KubeVip
  - currently supports: `KubeVip: v0.5.11`
- [hauler/kubewarden](hauler/kubewarden/README.md) - provides the content manifest for KubeWarden
  - currently supports: `KubeWarden: v1.27.0`

**Note:** We are currently planning and working towards supporting every major version of our products. We will continue to update to the latest until we implement previous major verions.

## Hauler Installation

```bash
# https://github.com/hauler-dev/hauler
curl -sfL https://get.hauler.dev | bash

# date = $(date +"%m%d%Y")
```
