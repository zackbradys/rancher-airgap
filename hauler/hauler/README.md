# Hauler

**Note:** View the [README](https://github.com/zackbradys/rancher-airgap/blob/main/README.md) for the latest versions!

## Collection and Packaging

[hauler/hauler/rancher-airgap-hauler.yaml](https://github.com/zackbradys/rancher-airgap/blob/v2.0.0/hauler/hauler/rancher-airgap-hauler.yaml) - provides the content manifest for all the assets.

```bash
# pull the manifest
curl -#OL https://raw.githubusercontent.com/zackbradys/rancher-airgap/v2.0.0/hauler/hauler/rancher-airgap-hauler.yaml

# sync to the store
hauler store sync --files rancher-airgap-hauler.yaml

# save to tarball
hauler store save --filename rancher-airgap-hauler.tar.zst
```

## Across the Airgap

```bash
# coming soon
```

## Loading and Distribution

```bash
# coming soon
```