### Set Variables
export vHauler=1.0.8

### Setup Working Directory
rm -rf /opt/hauler/hauler
mkdir -p /opt/hauler/hauler
cd /opt/hauler/hauler

### Create Hauler Manifest
### Hauler -> https://github.com/hauler-dev/hauler
cat << EOF >> /opt/hauler/hauler/rancher-airgap-hauler.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Files
metadata:
  name: rancher-airgap-files-hauler
spec:
  files:
    - path: https://github.com/hauler-dev/hauler/releases/download/v${vHauler}/hauler_${vHauler}_linux_amd64.tar.gz
      name: hauler-linux-amd64.tar.gz
    - path: https://github.com/hauler-dev/hauler/releases/download/v${vHauler}/hauler_${vHauler}_linux_arm64.tar.gz
      name: hauler-linux-arm64.tar.gz
    - path: https://github.com/hauler-dev/hauler/releases/download/v${vHauler}/hauler_${vHauler}_windows_amd64.tar.gz
      name: hauler-windows-amd64.tar.gz
    - path: https://github.com/hauler-dev/hauler/releases/download/v${vHauler}/hauler_${vHauler}_windows_arm64.tar.gz
      name: hauler-windows-arm64.tar.gz
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Charts
metadata:
  name: rancher-airgap-charts-hauler
spec:
  charts:
    - name: hauler-helm
      repoURL: oci://ghcr.io/hauler-dev
      version: ${vHauler}
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Images
metadata:
  name: rancher-airgap-images-hauler
spec:
  images:
    - name: ghcr.io/hauler-dev/hauler:v${vHauler}
    - name: ghcr.io/hauler-dev/hauler-debug:v${vHauler}
EOF

### Add the Hauler Manifest
hauler store add file rancher-airgap-hauler.yaml