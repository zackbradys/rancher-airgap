### Set Variables
export vHauler=1.0.0

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
      name: hauler.tar.gz
EOF