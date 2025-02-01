# Helm (by the CNCF)

**Note:** View the [README](https://github.com/zackbradys/rancher-airgap/blob/main/README.md) for the latest versions!

## Collection and Packaging

[hauler/helm/rancher-airgap-helm.yaml](https://github.com/zackbradys/rancher-airgap/blob/main/hauler/helm/rancher-airgap-helm.yaml) - provides the content manifest for all the assets.

```bash
# pull the manifest
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/helm/rancher-airgap-helm.yaml

# sync to the store
hauler store sync --files rancher-airgap-helm.yaml

# save to tarball
hauler store save --filename rancher-airgap-helm.tar.zst
```

## Across the Airgap

```bash
# coming soon
```

## Loading and Distribution

```bash
# coming soon
```
