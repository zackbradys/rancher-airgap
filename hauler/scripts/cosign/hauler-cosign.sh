### Set Variables
export vCosign=2.2.3

### Setup Working Directory
rm -rf /opt/rancher/hauler/cosign
mkdir -p /opt/rancher/hauler/cosign
cd /opt/rancher/hauler/cosign

### Create Hauler Manifest
### Cosign -> https://github.com/sigstore/cosign
cat << EOF >> /opt/rancher/hauler/cosign/rancher-airgap-cosign.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Files
metadata:
  name: rancher-airgap-files-cosign
spec:
  files:
    - path: https://github.com/sigstore/cosign/releases/download/v${vCosign}/cosign-linux-amd64
      name: cosign
EOF