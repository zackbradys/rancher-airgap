# K3S (by Rancher)

**Note:** View the [README](https://github.com/zackbradys/rancher-airgap/blob/main/README.md) for the latest versions!

## Collection and Packaging

[hauler/k3s/rancher-airgap-k3s.yaml](https://github.com/zackbradys/rancher-airgap/blob/main/hauler/k3s/rancher-airgap-k3s.yaml) - provides the content manifest for all the assets.

```bash
# pull the manifest
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/k3s/rancher-airgap-k3s.yaml

# sync to the store
hauler store sync --files rancher-airgap-k3s.yaml

# save to tarball
hauler store save --filename rancher-airgap-k3s.tar.zst
```

## Across the Airgap

```bash
# coming soon
```

## Loading and Distribution

```bash
# coming soon
```