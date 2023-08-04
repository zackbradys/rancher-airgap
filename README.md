![rancher-long-banner](/images/rgs-banner-rounded.png)

# Airgap Deployment of Rancher RKE2, Rancher Manager, Longhorn, and Neuvector

### Table of Contents
* [Introduction](#introduction)
* [Infrastructure](#infrastructure)
  * [Collection and Packaging](#collection-and-packaging)
  * [Across the Airgap](#across-the-airgap)
  * [Loading and Distribution](#loading-and-distribution)
* [RKE2 Configuration](#rke2-configuration)
* [Longhorn Configuration](#longhorn-configuration)
* [NeuVector Configuration](#neuvector-configuration)
* [Final Thoughts](#final-thoughts)

## Introduction

### Welcome to the Rancher Airgap Tool and Guide
Rancher Airgap is a tool built for collecting, packaging, installating Rancher RKE2, Rancher Manager, Longhorn and NeuVector. Specifically engineered, designed, and built for those tricky disconnected environments. **Review the most recent release on the [Releases](https://github.com/zackbradys/rancher-airgap/releases) page!**

We utilize a tool known as `Rancher Federal Hauler` ([https://github.com/rancherfederal/hauler](https://github.com/rancherfederal/hauler)) to collect, package, and distribute content across the airgap. `Hauler` simplifies the airgap process, by representing assets as content or collections to easily fetch and package them with declarative manifests. In this repositry, we generate these manifests and subsequent compress files to ease the burden of collecting all components required the airgap the [Rancher Stack](https://ranchergovernment.com/products)!

```bash
fetch -> validate -> save -> | <airgap> | -> validate -> load -> distribute
```

## Infrastructure

```bash
Collection and Package -> Across the Airgap -> Loading and Distribution
```

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

## RKE2 Configuration


## Rancher Configuration


## Longhorn Configuration


## NeuVector Configuration


## Final Thoughts