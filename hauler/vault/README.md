# Vault (by HashiCorp)

**Note:** View the [README](https://github.com/zackbradys/rancher-airgap/blob/main/README.md) for the latest versions!

## Collection and Packaging

[hauler/vault/rancher-airgap-vault.yaml](https://github.com/zackbradys/rancher-airgap/blob/main/hauler/vault/rancher-airgap-vault.yaml) - provides the content manifest for all the assets.

```bash
# pull the manifest
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/vault/rancher-airgap-vault.yaml

# sync to the store
hauler store sync --files rancher-airgap-vault.yaml

# save to tarball
hauler store save --filename rancher-airgap-vault.tar.zst
```

## Across the Airgap

```bash
# coming soon
```

## Loading and Distribution

```bash
# coming soon
```