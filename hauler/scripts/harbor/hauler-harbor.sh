### Set Variables
export vHarbor=1.14.0

### Setup Working Directory
rm -rf /opt/hauler/harbor
mkdir -p /opt/hauler/harbor
cd /opt/hauler/harbor

### Add Harbor Helm Chart Repos
helm repo add harbor https://helm.goharbor.io
helm repo update

### Download Harbor Images
### https://github.com/goharbor/harbor-helm
helm template harbor/harbor --version=${vHarbor} | grep 'image:' | sed 's/"//g' | awk '{ print $2 }' > harbor-images.txt
sed -i "s#^#    - name: #" harbor-images.txt

### Set Harbor Images Variable
harborImages=$(cat harbor-images.txt)

### Create Hauler Manifest
cat << EOF >> /opt/hauler/harbor/rancher-airgap-harbor.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Charts
metadata:
  name: rancher-airgap-charts-harbor
spec:
  charts:
    - name: harbor
      repoURL: https://harbor.github.io/harbor-helm
      version: ${vHarbor}
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Images
metadata:
  name: rancher-airgap-images-harbor
spec:
  images:
${harborImages}
EOF