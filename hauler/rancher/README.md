# Rancher Multi-Cluster-Manager (by Rancher)

**Note:** View the [README](https://github.com/zackbradys/rancher-airgap/blob/main/README.md) for the latest versions!

## Collection and Packaging

[hauler/rancher/rancher-airgap-rancher.yaml](https://github.com/zackbradys/rancher-airgap/blob/main/hauler/rancher/rancher-airgap-rancher.yaml) - provides the content manifest for all the assets.

```yaml
# pull the manifest
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/rancher/rancher-airgap-rancher.yaml

# sync to the store
hauler store sync --files rancher-airgap-rancher.yaml

# save to tarball
hauler store save --filename rancher-airgap-rancher.tar.zst
```

[hauler/rancher/rancher-airgap-rancher-minimal.yaml](https://github.com/zackbradys/rancher-airgap/blob/main/hauler/rancher/rancher-airgap-rancher-minimal.yaml) - provides the content manifest for the minimal assets.


```bash
# pull the manifest
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/rancher/rancher-airgap-rancher-minimal.yaml

# sync to the store
hauler store sync --files rancher-airgap-rancher-minimal.yaml

# save to tarball
hauler store save --filename rancher-airgap-rancher-minimal.tar.zst
```

## Across the Airgap

```bash
# coming soon
```

## Loading and Distribution

```bash
# coming soon
```