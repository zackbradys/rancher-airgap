#  Rancher NeuVector (by Rancher)

**Note:** View the [README](https://github.com/zackbradys/rancher-airgap/blob/main/README.md) for the latest versions!

## Collection and Packaging

[hauler/neuvector/rancher-airgap-neuvector.yaml](https://github.com/zackbradys/rancher-airgap/blob/main/hauler/neuvector/rancher-airgap-neuvector.yaml) - provides the content manifest for all the assets.

```bash
# pull the manifest
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/neuvector/rancher-airgap-neuvector.yaml

# sync to the store
hauler store sync --files rancher-airgap-neuvector.yaml

# save to tarball
hauler store save --filename rancher-airgap-neuvector.tar.zst
```

## Across the Airgap

```bash
# coming soon
```

## Loading and Distribution

```bash
# coming soon
```