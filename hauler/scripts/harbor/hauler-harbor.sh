### Set Variables
export vHarbor=1.14.0

### Setup Working Directory
rm -rf /opt/hauler/harbor
mkdir -p /opt/hauler/harbor
cd /opt/hauler/harbor

### Download Harbor Images and Modify the List
### https://github.com/goharbor/harbor-helm
helm repo add goharbor https://helm.goharbor.io && helm repo update
harborImages=$(helm template goharbor/harbor --version=${vHarbor} | grep 'image:' | sed 's/"//g; s/.*image: //' | sed 's/^/    - name: /')

### Create Hauler Manifest
cat << EOF >> /opt/hauler/harbor/rancher-airgap-harbor.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Charts
metadata:
  name: rancher-airgap-charts-harbor
spec:
  charts:
    - name: harbor
      repoURL: https://helm.goharbor.io
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