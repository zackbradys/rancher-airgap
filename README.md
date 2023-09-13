![rancher-long-banner](images/rgs-banner-rounded.png)

# Rancher Airgap Guide

### Welcome to the Rancher Airgap Guide
Rancher Airgap is a framework and guide built for collecting, packaging, installating Rancher RKE2, Rancher Manager, Longhorn and NeuVector. Specifically engineered, designed, and built for those tricky disconnected environments. **Review the most recent release on the [Releases](https://github.com/zackbradys/rancher-airgap/releases) page!**

We utilize the [Hauler](https://github.com/rancherfederal/hauler) project by [Rancher Government Solutions](https://github.com/rancherfederal) to collect, package, and distribute content. `Hauler` simplifies the airgap process, by representing assets as content or collections and allows users to easily fetch, store, and package with declarative manifests. In this repositry, we generate these manifests and subsequent compressed tars, aka `stores`, to simplify the airgap process and the burden of collecting all components required to the airgap the [Rancher Product Stack](https://ranchergovernment.com/products).

**High Level Workflow:**
```bash
Collection -> Across the Airgap -> Distribution
```

**Detailed Workflow:**
```bash
fetch -> validate -> save -> | <airgap> | -> validate -> load -> distribute
```

**Example Workflows:** [examples folder](examples/)

## Repository Structure

### Products
* [hauler/rke2](hauler/rke2/README.md) - provides the content manifest for Rancher RKE2
  * currently supports: `RKE2 v1.25.13`
* [hauler/rancher](hauler/rancher/README.md) - provides the content manifest for Cert-Manager
  * currently supports: `Cert-Manager v1.7.1`
* [hauler/rancher](hauler/rancher/README.md) - provides the content manifest for Rancher Multi-Cluster Manager
  * currently supports: `Rancher v2.7.6`
* [hauler/longhorn](hauler/longhorn/README.md) - provides the content manifest for Rancher Longhorn
  * currently supports: `Longhorn v1.5.1`
* [hauler/neuvector](hauler/neuvector/README.md) - provides the content manifest for Rancher NeuVector
  * currently supports: `NeuVector v5.2.1`

### Addons
* [hauler/hauler](hauler/hauler/README.md) - provides the content manifest for Hauler
  * currently supports: `Hauler v0.3.0`
* [hauler/helm](hauler/helm/README.md) - provides the content manifest for Helm
  * currently supports: `Helm v3.12.3`

**Note:** We are currently planning and working towards supporting every major supported version of our products. We will continue to update to the latest until we implement previous major verions.

## Hauler Installation

```bash
### Hauler v0.3.0 (latest)
### https://github.com/rancherfederal/hauler
curl -#OL https://github.com/rancherfederal/hauler/releases/download/v0.3.0/hauler_0.3.0_linux_amd64.tar.gz
tar -xf hauler_0.3.0_linux_amd64.tar.gz
cp hauler /usr/bin/hauler
```