### Set Variables
export vNeuVector=2.6.0

### Setup Working Directory
mkdir -p /opt/rancher/hauler/neuvector
cd /opt/rancher/hauler/neuvector

### Add NeuVector Helm Chart Repos
helm repo add neuvector https://neuvector.github.io/neuvector-helm
helm repo update

### Download NeuVector Images
### https://github.com/neuvector/neuvector
helm template neuvector/core --version=${vNeuVector} | grep 'image:' | sed 's/"//g' | awk '{ print $2 }' > neuvector-images.txt
sed -i "s#^#    - name: #" neuvector-images.txt

### Set Rancher Images Variable
neuvectorImages=$(cat neuvector-images.txt)
rm -rf /opt/rancher/hauler/neuvector/neuvector-images.txt

### Create Hauler Manifest
cat << EOF >> /opt/rancher/hauler/neuvector/rancher-offline-neuvector.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Charts
metadata:
  name: rancher-offline-charts-neuvector
spec:
  charts:
    - name: core
      repoURL: https://neuvector.github.io/neuvector-helm
      version: ${vNeuVector}
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Images
metadata:
  name: rancher-offline-images-neuvector
spec:
  images:
${neuvectorImages}
EOF

### Load Hauler Manifest into Store
hauler store sync -f rancher-offline-neuvector.yaml

### Verify Hauler Store Contents
hauler store info

### Compress Hauler Store Contents
hauler store save --filename rancher-offline-neuvector.tar.zst
rm -rf /opt/rancher/hauler/neuvector/store