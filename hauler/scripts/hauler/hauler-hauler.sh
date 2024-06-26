### Set Variables
export vHauler=1.0.4

### Setup Working Directory
rm -rf /opt/hauler/hauler
mkdir -p /opt/hauler/hauler
cd /opt/hauler/hauler

### Create Hauler Manifest
### Hauler -> https://github.com/rancherfederal/hauler
cat << EOF >> /opt/hauler/hauler/rancher-airgap-hauler.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Files
metadata:
  name: rancher-airgap-files-hauler
spec:
  files:
    - path: https://github.com/rancherfederal/hauler/releases/download/v${vHauler}/hauler_${vHauler}_linux_amd64.tar.gz
      name: hauler-linux-amd64.tar.gz
    - path: https://github.com/rancherfederal/hauler/releases/download/v${vHauler}/hauler_${vHauler}_linux_arm64.tar.gz
      name: hauler-linux-arm64.tar.gz
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Charts
metadata:
  name: rancher-airgap-charts-hauler
spec:
  charts:
    - name: hauler
      repoURL: oci://ghcr.io/rancherfederal/charts
      version: ${vHauler}
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Images
metadata:
  name: rancher-airgap-images-hauler
spec:
  images:
    - name: ghcr.io/rancherfederal/hauler:v${vHauler}
EOF