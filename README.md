# Rancher Airgap Guide

### Welcome to the Rancher Airgap Guide
Rancher Airgap is a framework and guide built for collecting, packaging, distributing, and installing the Rancher Product Stack in airgapped environments. Such as RKE2, Rancher Manager, Longhorn and NeuVector.

We utilize the [Hauler](https://github.com/rancherfederal/hauler) project by [Rancher Government Solutions](https://github.com/rancherfederal) to collect, package, and distribute assets. `Hauler` simplifies the airgap process, by representing assets as content and collections and allows users to easily fetch, store, package, and distribute with declarative manifests or the command line. In this repositry, we generate these manifests and subsequent compressed archives aka `stores` for the Rancher Product Stack.

**Review the most recent *[releases](https://github.com/zackbradys/rancher-airgap/releases)* or the high level *[example use cases](examples)*!**

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
* [hauler/rke2](hauler/rke2/README.md) - provides the content manifest for Rancher Kubernetes (RKE2)
  * currently supports: `RKE2 v1.26.11`
* [hauler/rancher](hauler/rancher/README.md) - provides the content manifest for Cert-Manager
  * currently supports: `Cert-Manager v1.13.3`
* [hauler/rancher](hauler/rancher/README.md) - provides the content manifest for Rancher Multi-Cluster Manager
  * currently supports: `Rancher v2.8.0`
* [hauler/longhorn](hauler/longhorn/README.md) - provides the content manifest for Rancher Longhorn
  * currently supports: `Longhorn v1.5.3`
* [hauler/neuvector](hauler/neuvector/README.md) - provides the content manifest for Rancher NeuVector
  * currently supports: `NeuVector v5.2.4`
* [hauler/harvester](hauler/harvester/README.md) - provides the content manifest for Rancher Harvester
  * currently supports: `Harvester v1.2.1`

### Addons
* [hauler/hauler](hauler/hauler/README.md) - provides the content manifest for Hauler
  * currently supports: `Hauler v0.4.0`
* [hauler/helm](hauler/helm/README.md) - provides the content manifest for Helm
  * currently supports: `Helm v3.13.3`
* [hauler/cosign](hauler/cosign/README.md) - provides the content manifest for Cosign
  * currently supports: `Cosign v2.22.1`

**Note:** We are currently planning and working towards supporting every major version of our products. We will continue to update to the latest until we implement previous major verions.

## Hauler Installation
```bash
### Hauler v0.4.0 (latest)
### https://github.com/rancherfederal/hauler
curl -#OL https://github.com/rancherfederal/hauler/releases/download/v0.4.0/hauler_0.4.0_linux_amd64.tar.gz
tar -xf hauler_0.4.0_linux_amd64.tar.gz && sudo cp hauler /usr/bin/hauler
```