### Set Variables
export vHelm=3.13.3

### Setup Working Directory
rm -rf /opt/rancher/hauler/helm
mkdir -p /opt/rancher/hauler/helm
cd /opt/rancher/hauler/helm

### Create Hauler Manifest
### Helm -> https://github.com/helm/helm
cat << EOF >> /opt/rancher/hauler/helm/rancher-airgap-helm.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Files
metadata:
  name: rancher-airgap-files-helm
spec:
  files:
    - path: https://get.helm.sh/helm-v${vHelm}-linux-amd64.tar.gz
      name: helm.tar.gz
EOF

### Load Hauler Manifest into Store
hauler store sync -f rancher-airgap-helm.yaml

### Compress Hauler Store Contents
hauler store save --filename rancher-airgap-helm.tar.zst