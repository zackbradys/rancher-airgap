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
cat << EOF >> /opt/rancher/hauler/neuvector/rancher-airgap-neuvector-${OS}.yaml
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

### Set OS Release Variable
export OS=$(. /etc/os-release && echo "$ID"-"$PLATFORM_ID" | sed "s#platform:##")

### Load Hauler Manifest into Store
hauler store sync -f rancher-airgap-neuvector-${OS}.yaml

### Verify Hauler Store Contents
hauler store info

### Remove Working Directory
rm -rf /opt/rancher/hauler/neuvector/store