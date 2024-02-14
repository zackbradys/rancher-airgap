# KubeVip (by the CNCF)

**Note:** View the [README](https://github.com/zackbradys/rancher-airgap/blob/main/README.md) for the latest versions!

## Collection and Packaging

[hauler/kubevip/rancher-airgap-kubevip.yaml](https://github.com/zackbradys/rancher-airgap/blob/main/hauler/kubevip/rancher-airgap-kubevip.yaml) - provides the content manifest for all the assets.

```bash
# pull the manifest
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/kubevip/rancher-airgap-kubevip.yaml

# sync to the store
hauler store sync --files rancher-airgap-kubevip.yaml

# save to tarball
hauler store save --filename rancher-airgap-kubevip.tar.zst
```

## Across the Airgap

```bash
# coming soon
```

## Loading and Distribution

```bash
# coming soon
```