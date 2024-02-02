### Set Variables
export vLonghorn=1.5.3

### Setup Working Directory
rm -rf /opt/rancher/hauler/longhorn
mkdir -p /opt/rancher/hauler/longhorn
cd /opt/rancher/hauler/longhorn

### Download Longhorn Images
### https://github.com/longhorn/longhorn
curl -#L https://raw.githubusercontent.com/longhorn/longhorn/v${vLonghorn}/deploy/longhorn-images.txt -o longhorn-images.txt
sed -i "s#^#    - name: #" longhorn-images.txt

### Set Longhorn Images Variable
longhornImages=$(cat longhorn-images.txt)

### Create Hauler Manifest
cat << EOF >> /opt/rancher/hauler/longhorn/rancher-airgap-longhorn.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
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
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Charts
metadata:
  name: rancher-airgap-charts-longhorn
spec:
  charts:
    - name: longhorn
      repoURL: https://charts.longhorn.io
      version: ${vLonghorn}
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Images
metadata:
  name: rancher-airgap-images-longhorn
spec:
  images:
${longhornImages}
EOF