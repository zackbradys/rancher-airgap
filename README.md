![rancher-long-banner](/images/rgs-banner-rounded.png)

# Rancher Airgap Tool and Guide

### Welcome to the Rancher Airgap Tool
Rancher Airgap is a tool built for collecting, packaging, installating Rancher RKE2, Rancher Manager, Longhorn and NeuVector. Specifically engineered, designed, and built for those tricky disconnected environments. **Review the most recent release on the [Releases](https://github.com/zackbradys/rancher-airgap/releases) page!**

We utilize a project known as [Hauler](https://github.com/rancherfederal/hauler) by [Rancher Government Solutions](https://github.com/rancherfederal) to collect, package, and distribute content across the airgap. `Hauler` simplifies the airgap process, by representing assets as content or collections to easily fetch, store, and package with declarative manifests. In this repositry, we generate these manifests and subsequent compressed files ("stores") to ease the burden of collecting all components required to the airgap the [Rancher Stack](https://ranchergovernment.com/products)!

**High Level Workflow:**
```bash
Collection -> Across the Airgap -> Distribution
```

**Detailed Workflow:**
```bash
fetch -> validate -> save -> | <airgap> | -> validate -> load -> distribute
```

**Example Workflow:** [examples/rancherstack.md](examples/rancherstack.md)

## Repository Structure

* [hauler/base](hauler/base/README.md) - provides the content manifest for most Operating System Dependencies
  * currently supports and validated: `Rocky 9.1` `RHEL 9.1` `Rocky 8.5` `RHEL 8.5` `CentOS 7.8`
* [hauler/rke2](hauler/rke2/README.md) - provides the content manifest for Rancher RKE2
  * currently supports: `RKE2 v1.25.12`
* [hauler/rancher](hauler/rancher/README.md) - provides the content manifest for the Rancher Multi-Cluster Manager
  * currently supports: `Rancher v2.7.5`
* [hauler/longhorn](hauler/longhorn/README.md) - provides the content manifest for Rancher Longhorn
  * currently supports: `Longhorn v1.5.1`
* [hauler/neuvector](hauler/neuvector/README.md) - provides the content manifest for Rancher NeuVector
  * currently supports: `NeuVector v5.2.0`

## Hauler Installation

```bash
### Hauler v0.3.0 (latest)
### https://github.com/rancherfederal/hauler
curl -#OL https://github.com/rancherfederal/hauler/releases/download/v0.3.0/hauler_0.3.0_linux_amd64.tar.gz
tar -xf hauler_0.3.0_linux_amd64.tar.gz
cp hauler /usr/bin/hauler
```