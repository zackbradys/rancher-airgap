### Set Variables
export vVault=0.28.1

### Setup Working Directory
rm -rf /opt/hauler/vault
mkdir -p /opt/hauler/vault
cd /opt/hauler/vault

### Download Vault Images and Modify the List
### https://github.com/hashicorp/vault-helm
helm repo add hashicorp https://helm.releases.hashicorp.com && helm repo update
vaultImages=$(helm template hashicorp/vault --version=${vGitea} | grep 'image:' | sed 's/"//g; s/.*image: //' | sed 's/^/    - name: /')

### Create Hauler Manifest
cat << EOF >> /opt/hauler/vault/rancher-airgap-vault.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Charts
metadata:
  name: rancher-airgap-charts-vault
spec:
  charts:
    - name: vault
      repoURL: https://helm.releases.hashicorp.com
      version: ${vVault}
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Images
metadata:
  name: rancher-airgap-images-vault
spec:
  images:
${vaultImages}
EOF

### Add the Hauler Manifest
hauler store add file rancher-airgap-vault.yaml
