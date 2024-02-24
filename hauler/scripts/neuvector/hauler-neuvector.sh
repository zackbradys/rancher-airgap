### Set Variables
export vNeuVector=2.7.3

### Setup Working Directory
rm -rf /opt/hauler/neuvector
mkdir -p /opt/hauler/neuvector
cd /opt/hauler/neuvector

### Download NeuVector Images and Modify the List
### https://github.com/neuvector/neuvector
helm repo add neuvector https://neuvector.github.io/neuvector-helm && helm repo update
neuvectorImages=$(helm template neuvector/core --version=${vNeuVector} | grep 'image:' | sed 's/"//g' | sed 's/docker.io\///g' | awk '{ print "    - name: " $2 }')

### Create Hauler Manifest
cat << EOF >> /opt/hauler/neuvector/rancher-airgap-neuvector.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Charts
metadata:
  name: rancher-airgap-charts-neuvector
spec:
  charts:
    - name: core
      repoURL: https://neuvector.github.io/neuvector-helm
      version: ${vNeuVector}
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Images
metadata:
  name: rancher-airgap-images-neuvector
spec:
  images:
${neuvectorImages}
EOF