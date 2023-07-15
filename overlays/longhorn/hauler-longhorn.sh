### Set Variables
export vLonghorn=1.5.0

### Setup Working Directory
mkdir -p /opt/rancher/hauler/longhorn
cd /opt/rancher/hauler/longhorn

curl -#L https://raw.githubusercontent.com/longhorn/longhorn/v${vLonghorn}/deploy/longhorn-images.txt -o longhorn-images.txt
sed -i "s#^#    - name: #" longhorn-images.txt

### Set Rancher Images Variable
longhornImages=$(cat longhorn-images.txt)
rm -rf /opt/rancher/hauler/longhorn/longhorn-images.txt

### Create Hauler Manifest
cat << EOF >> /opt/rancher/hauler/longhorn/rancher-offline-longhorn.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Files
metadata:
  name: rancher-offline-files-longhorn
spec:
  files:
    - path: https://github.com/zackbradys/code-templates/blob/main/k8s/yamls/longhorn-volume.yaml
      name: longhorn-volume
    - path: https://github.com/zackbradys/code-templates/blob/main/k8s/yamls/longhorn-volume-test.yaml
      name: longhorn-volume-test
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Charts
metadata:
  name: rancher-offline-charts-longhorn
spec:
  charts:
    - name: longhorn
      repoURL: https://charts.longhorn.io
      version: ${vLonghorn}
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Images
metadata:
  name: rancher-offline-images-longhorn
spec:
  images:
${longhornImages}
EOF

### Load Hauler Manifest into Store
hauler store sync -f rancher-offline-longhorn.yaml

### Verify Hauler Store Contents
hauler store info

### Compress Hauler Store Contents
hauler store save --filename rancher-offline-longhorn.tar.zst
rm -rf /opt/rancher/hauler/longhorn/store