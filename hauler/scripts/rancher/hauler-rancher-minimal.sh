### Set Variables
export vRancher=2.7.9
export vCertManager=v1.13.3

### Setup Working Directory
cd /opt/rancher/hauler/rancher

### Download Cert Manager Images
### https://github.com/cert-manager/cert-manager
helm repo add jetstack https://charts.jetstack.io && helm repo update
helm template jetstack/cert-manager --version=${vCertManager} | grep 'image:' | sed 's/"//g' | awk '{ print $2 }' > cert-manager-images-minimal.txt
sed -i "s#^#    - name: #" cert-manager-images-minimal.txt

### Set Cert-Manager Images Variable
certmanagerImagesMinimal=$(cat cert-manager-images-minimal.txt)

### Download Rancher Images
### https://github.com/rancher/rancher
curl -#L https://github.com/rancher/rancher/releases/download/v${vRancher}/rancher-images.txt -o rancher-images-minimal.txt
sed -i '/neuvector\|minio\|gke\|aks\|eks\|sriov\|harvester\|mirrored\|longhorn\|thanos\|tekton\|istio\|multus\|hyper\|jenkins\|prom\|grafana\|windows/d' rancher-images-minimal.txt
sed -i "s#^#    - name: #" rancher-images-minimal.txt

### Set Rancher Images Variable
rancherImagesMinimal=$(cat rancher-images-minimal.txt)

### Create Hauler Manifest
cat << EOF >> /opt/rancher/hauler/rancher/rancher-airgap-rancher-minimal.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Files
metadata:
  name: rancher-airgap-files-rancher-minimal
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
  name: rancher-airgap-charts-rancher-minimal
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
  name: rancher-airgap-images-rancher-minimal
spec:
  images:
${certmanagerImagesMinimal}
${rancherImagesMinimal}
EOF

### Load Hauler Manifest into Store
hauler store sync -f rancher-airgap-rancher-minimal.yaml

### Compress Hauler Store Contents
hauler store save --filename rancher-airgap-rancher-minimal.tar.zst