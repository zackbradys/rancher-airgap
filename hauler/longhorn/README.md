# Rancher Longhorn (by Rancher)

**Note:** View the [README](https://github.com/zackbradys/rancher-airgap/blob/main/README.md) for the latest versions!

## Collection and Packaging

[hauler/longhorn/rancher-airgap-longhorn.yaml](https://github.com/zackbradys/rancher-airgap/blob/main/hauler/longhorn/rancher-airgap-longhorn.yaml) - provides the content manifest for all the assets.

```bash
# pull the manifest
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/longhorn/rancher-airgap-longhorn.yaml

# sync to the store
hauler store sync --files rancher-airgap-longhorn.yaml

# save to tarball
hauler store save --filename rancher-airgap-longhorn.tar.zst
```

## Across the Airgap

```bash
# coming soon
```

## Loading and Distribution

```bash
# coming soon
```