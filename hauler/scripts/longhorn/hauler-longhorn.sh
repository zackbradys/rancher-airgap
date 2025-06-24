# Set Variables
export vLonghorn=1.8.2

# Setup Working Directory
rm -rf /opt/hauler/longhorn
mkdir -p /opt/hauler/longhorn
cd /opt/hauler/longhorn

# Download Longhorn Images and Modify the List
# https://github.com/longhorn/longhorn
longhornImages=$(curl -sSfL https://raw.githubusercontent.com/longhorn/longhorn/v${vLonghorn}/deploy/longhorn-images.txt | sed -e "s/^/    - name: /")

# Create Hauler Manifest
cat << EOF >> /opt/hauler/longhorn/rancher-airgap-longhorn.yaml
apiVersion: content.hauler.cattle.io/v1
kind: Files
metadata:
  name: rancher-airgap-files-longhorn
spec:
  files:
    - path: https://raw.githubusercontent.com/zackbradys/code-templates/main/k8s/yamls/longhorn-encrypted-sc.yaml
      name: longhorn-encrypted-sc.yaml
    - path: https://raw.githubusercontent.com/zackbradys/code-templates/main/k8s/yamls/longhorn-encrypted-volume.yaml
      name: longhorn-encrypted-volume.yaml
---
apiVersion: content.hauler.cattle.io/v1
kind: Charts
metadata:
  name: rancher-airgap-charts-longhorn
spec:
  charts:
    - name: longhorn
      repoURL: https://charts.longhorn.io
      version: ${vLonghorn}
---
apiVersion: content.hauler.cattle.io/v1
kind: Images
metadata:
  name: rancher-airgap-images-longhorn
spec:
  images:
${longhornImages}
EOF
