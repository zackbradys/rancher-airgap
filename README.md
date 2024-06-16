# Rancher Airgap Guide

### Welcome to the Rancher Airgap Guide

Rancher Airgap is a framework and guide built for collecting, packaging, and distributing the Rancher Product Stack for deployment in disconnected or airgapped environments.

We utilize Project [Hauler](https://github.com/rancherfederal/hauler) by [Rancher Government Solutions](https://github.com/rancherfederal) to collect, package, and distribute the assets. `Hauler` simplifies the airgap process, by representing assets as content and collections and allows users to easily fetch, store, package, and distribute with declarative manifests or the command line. In this repositry, we generate these manifests for each of the products.

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
  - currently supports: `RKE2: v1.27.14`
- [hauler/rancher](hauler/rancher/README.md) - provides the content manifest for Cert-Manager
  - currently supports: `Cert-Manager: v1.15.0`
- [hauler/rancher](hauler/rancher/README.md) - provides the content manifest for Rancher Multi-Cluster Manager
  - currently supports: `Rancher: v2.8.4`
- [hauler/longhorn](hauler/longhorn/README.md) - provides the content manifest for Rancher Longhorn
  - currently supports: `Longhorn: v1.6.2`
- [hauler/neuvector](hauler/neuvector/README.md) - provides the content manifest for Rancher NeuVector
  - currently supports: `NeuVector: v5.3.3`
- [hauler/harvester](hauler/harvester/README.md) - provides the content manifest for Rancher Harvester
  - currently supports: `Harvester: v1.3.1`

### Addons

- [hauler/hauler](hauler/hauler/README.md) - provides the content manifest for Hauler
  - currently supports: `Hauler: v1.0.3`
- [hauler/helm](hauler/helm/README.md) - provides the content manifest for Helm
  - currently supports: `Helm: v3.15.2`
- [hauler/cosign](hauler/cosign/README.md) - provides the content manifest for Cosign
  - currently supports: `Cosign: v2.2.4`
- [hauler/harbor](hauler/harbor/README.md) - provides the content manifest for Harbor
  - currently supports: `Harbor: v2.10.2`
- [hauler/kubevip](hauler/kubevip/README.md) - provides the content manifest for KubeVip
  - currently supports: `KubeVip: Latest`

**Note:** We are currently planning and working towards supporting every major version of our products. We will continue to update to the latest until we implement previous major verions.

## Hauler Installation

```bash
# https://github.com/rancherfederal/hauler
curl -sfL https://get.hauler.dev | bash
```
