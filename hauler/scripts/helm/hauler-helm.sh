# Set Variables
export vHelm=3.18.4

# Setup Working Directory
rm -rf /opt/hauler/helm
mkdir -p /opt/hauler/helm
cd /opt/hauler/helm

# Create Hauler Manifest
# Helm -> https://github.com/helm/helm
cat << EOF >> /opt/hauler/helm/rancher-airgap-helm.yaml
apiVersion: content.hauler.cattle.io/v1
kind: Files
metadata:
  name: rancher-airgap-files-helm
spec:
  files:
    - path: https://get.helm.sh/helm-v${vHelm}-linux-amd64.tar.gz
      name: helm-linux-amd64.tar.gz
    - path: https://get.helm.sh/helm-v${vHelm}-linux-arm64.tar.gz
      name: helm-linux-amd64.tar.gz
EOF
