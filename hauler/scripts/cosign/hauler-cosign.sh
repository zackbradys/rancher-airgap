### Set Variables
export vCosign=2.22.0

### Setup Working Directory
rm -rf /opt/rancher/hauler/cosign
mkdir -p /opt/rancher/hauler/cosign
cd /opt/rancher/hauler/cosign

### Download Cosign
### https://github.com/sigstore/cosign
curl -#OL https://github.com/sigstore/cosign/releases/download/v${vCosign}/cosign-linux-amd64
mv cosign-linux-amd64 cosign && chmod 755 cosign

### Create Hauler Manifest
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

### Load Hauler Manifest into Store
hauler store sync -f rancher-airgap-cosign.yaml

### Compress Hauler Store Contents
hauler store save --filename rancher-airgap-cosign.tar.zst