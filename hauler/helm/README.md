# Helm

**Note:** View the [README](https://github.com/zackbradys/rancher-airgap/blob/main/README.md) for the latest versions!

## Collection and Packaging

[hauler/helm/rancher-airgap-helm.yaml](https://github.com/zackbradys/rancher-airgap/blob/v2.0.0/hauler/helm/rancher-airgap-helm.yaml) - provides the content manifest for all the assets.

```bash
# pull the manifest
curl -#OL https://raw.githubusercontent.com/zackbradys/rancher-airgap/v2.0.0/hauler/helm/rancher-airgap-helm.yaml

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