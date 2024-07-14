### Set Variables
export vCosign=2.2.4

### Setup Working Directory
rm -rf /opt/hauler/cosign
mkdir -p /opt/hauler/cosign
cd /opt/hauler/cosign

### Create Hauler Manifest
### Cosign -> https://github.com/sigstore/cosign
cat << EOF >> /opt/hauler/cosign/rancher-airgap-cosign.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Files
metadata:
  name: rancher-airgap-files-cosign
spec:
  files:
    - path: https://github.com/sigstore/cosign/releases/download/v${vCosign}/cosign-linux-amd64
      name: cosign-linux-amd64
    - path: https://github.com/sigstore/cosign/releases/download/v${vCosign}/cosign-linux-arm64
      name: cosign-linux-arm64
EOF

### Add the Hauler Manifest
hauler store add file rancher-airgap-cosign.yaml
