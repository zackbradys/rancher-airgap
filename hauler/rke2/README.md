# Rancher Kubernetes Engine 2 (by Rancher)

**Note:** View the [README](https://github.com/zackbradys/rancher-airgap/blob/main/README.md) for the latest versions!

## Collection and Packaging

[hauler/rke2/rancher-airgap-rke2.yaml](https://github.com/zackbradys/rancher-airgap/blob/main/hauler/rke2/rancher-airgap-rke2.yaml) - provides the content manifest for all the assets.

```bash
# pull the manifest
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/rke2/rancher-airgap-rke2.yaml

# sync to the store
hauler store sync --files rancher-airgap-rke2.yaml

# save to tarball
hauler store save --filename rancher-airgap-rke2.tar.zst
```

## Across the Airgap

```bash
# coming soon
```

## Loading and Distribution

```bash
# coming soon
```