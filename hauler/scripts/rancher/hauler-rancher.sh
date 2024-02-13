### Set Variables
export vRancher=2.8.2
export vCertManager=v1.14.2

### Setup Working Directory
rm -rf /opt/rancher/hauler/rancher
mkdir -p /opt/rancher/hauler/rancher
cd /opt/rancher/hauler/rancher

### Download Cert Manager Images
### https://github.com/cert-manager/cert-manager
helm repo add jetstack https://charts.jetstack.io && helm repo update
helm template jetstack/cert-manager --version=${vCertManager} | grep 'image:' | sed 's/"//g' | awk '{ print $2 }' > cert-manager-images.txt
sed -i "s#^#    - name: #" cert-manager-images.txt

### Set Cert-Manager Images Variable
certmanagerImages=$(cat cert-manager-images.txt)

### Download Rancher Images
### https://github.com/rancher/rancher
curl -#L https://github.com/rancher/rancher/releases/download/v${vRancher}/rancher-images.txt -o rancher-images.txt
sed -i "s#^#    - name: #" rancher-images.txt

### Set Rancher Images Variable
rancherImages=$(cat rancher-images.txt)

### Create Hauler Manifest
cat << EOF >> /opt/rancher/hauler/rancher/rancher-airgap-rancher.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Files
metadata:
  name: rancher-airgap-files-rancher
spec:
  files:
    - path: https://raw.githubusercontent.com/zackbradys/code-templates/main/k8s/yamls/rancher-banner-ufouo.yaml
      name: rancher-banner-ufouo.yaml
    - path: https://raw.githubusercontent.com/zackbradys/code-templates/main/k8s/yamls/rancher-banner-tssci.yaml
      name: rancher-banner-tssci.yaml
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Charts
metadata:
  name: rancher-airgap-charts-rancher
spec:
  charts:
    - name: cert-manager
      repoURL: https://charts.jetstack.io
      version: ${vCertManager}
    - name: rancher
      repoURL: https://releases.rancher.com/server-charts/latest
      version: ${vRancher}
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Images
metadata:
  name: rancher-airgap-images-rancher
spec:
  images:
${certmanagerImages}
${rancherImages}
EOF