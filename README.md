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

We utilize a purpose built tool known as `Rancher Federal Hauler` ([https://github.com/rancherfederal/hauler](https://github.com/rancherfederal/hauler)) to collect, package, and distribute content across the airgap. `Hauler` simplifies the airgap process, by representing components as content or collections to easily collect and package them with manifests. In this repositry, we generate these manifests and subsequent compress files to ease the burden of collecting all components required the airgap the [Rancher Stack](https://ranchergovernment.com/products)!

```bash
fetch -> validate -> save -> | <airgap> | -> validate -> load -> distribute
```

## Infrastructure

### Collection and Packaging

* [hauler/base](hauler/base) - provides the content manifest for most Operating System Dependencies
  * currently supports Rocky 9.1, RHEL 9.1, Rocky 8.5, RHEL 8.5, and CentOS 7.8
* [hauler/rke2](hauler/rke2) - provides the content manifest for Rancher RKE2
  * currently supports RKE2 1.24.15
* [hauler/rancher](hauler/rancher) - provides the content manifest for the Rancher Multi-Cluster Manager
  * currently supports Rancher 2.7.5
* [hauler/longhorn](hauler/longhorn) - provides the content manifest for Rancher Longhorn
  * currently supports Longhorn 1.5.0
* [hauler/neuvector](hauler/neuvector) - provides the content manifest for Rancher NeuVector
  * currently supports NeuVector 5.2.0

### Across the Airgap


### Loading and Distribution


## RKE2 Configuration


## Rancher Configuration


## Longhorn Configuration


## NeuVector Configuration


## Final Thoughts
