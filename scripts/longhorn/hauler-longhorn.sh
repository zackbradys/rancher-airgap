### Set Variables
export vLonghorn=1.5.0

### Setup Working Directory
mkdir -p /opt/rancher/hauler/longhorn
cd /opt/rancher/hauler/longhorn

### Download Longhorn Images
### https://github.com/longhorn/longhorn
curl -#L https://raw.githubusercontent.com/longhorn/longhorn/v${vLonghorn}/deploy/longhorn-images.txt -o longhorn-images.txt
sed -i "s#^#    - name: #" longhorn-images.txt

### Set Rancher Images Variable
longhornImages=$(cat longhorn-images.txt)
rm -rf /opt/rancher/hauler/longhorn/longhorn-images.txt

### Create Hauler Manifest
cat << EOF >> /opt/rancher/hauler/longhorn/rancher-airgap-longhorn-${OS}.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Files
metadata:
  name: rancher-airgap-files-longhorn
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

### Set OS Release Variable
export OS=$(. /etc/os-release && echo "$ID"-"$PLATFORM_ID" | sed "s#platform:##")

### Load Hauler Manifest into Store
hauler store sync -f rancher-airgap-longhorn-${OS}.yaml

### Verify Hauler Store Contents
hauler store info

### Remove Working Directory
rm -rf /opt/rancher/hauler/longhorn/store