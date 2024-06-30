# Gitea (by Gitea)

**Note:** View the [README](https://github.com/zackbradys/rancher-airgap/blob/main/README.md) for the latest versions!

## Collection and Packaging

[hauler/gitea/rancher-airgap-gitea.yaml](https://github.com/zackbradys/rancher-airgap/blob/main/hauler/gitea/rancher-airgap-gitea.yaml) - provides the content manifest for all the assets.

```bash
# pull the manifest
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/gitea/rancher-airgap-gitea.yaml

# sync to the store
hauler store sync --files rancher-airgap-gitea.yaml

# save to tarball
hauler store save --filename rancher-airgap-gitea.tar.zst
```

## Across the Airgap

```bash
# coming soon
```

## Loading and Distribution

```bash
# coming soon
```