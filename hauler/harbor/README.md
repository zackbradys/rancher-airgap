# Harbor (by the CNCF)

**Note:** View the [README](https://github.com/zackbradys/rancher-airgap/blob/main/README.md) for the latest versions!

## Collection and Packaging

[hauler/harbor/rancher-airgap-harbor.yaml](https://github.com/zackbradys/rancher-airgap/blob/main/hauler/harbor/rancher-airgap-harbor.yaml) - provides the content manifest for all the assets.

```bash
# pull the manifest
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/harbor/rancher-airgap-harbor.yaml

# sync to the store
hauler store sync --files rancher-airgap-harbor.yaml

# save to tarball
hauler store save --filename rancher-airgap-harbor.tar.zst
```

## Across the Airgap

```bash
# coming soon
```

## Loading and Distribution

```bash
# coming soon
```