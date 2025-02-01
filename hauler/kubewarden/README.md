# Kubewarden (by Rancher)

**Note:** View the [README](https://github.com/zackbradys/rancher-airgap/blob/main/README.md) for the latest versions!

## Collection and Packaging

[hauler/kubewarden/rancher-airgap-kubewarden.yaml](https://github.com/zackbradys/rancher-airgap/blob/main/hauler/kubewarden/rancher-airgap-kubewarden.yaml) - provides the content manifest for all the assets.

```bash
# pull the manifest
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/kubewarden/rancher-airgap-kubewarden.yaml

# sync to the store
hauler store sync --files rancher-airgap-kubewarden.yaml

# save to tarball
hauler store save --filename rancher-airgap-kubewarden.tar.zst
```

## Across the Airgap

```bash
# coming soon
```

## Loading and Distribution

```bash
# coming soon
```
