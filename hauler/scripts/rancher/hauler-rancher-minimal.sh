### Set Variables
export vRancher=2.9.2
export vCertManager=1.15.3

### Setup Working Directory
rm -rf /opt/hauler/rancher-minimal
mkdir -p /opt/hauler/rancher-minimal
cd /opt/hauler/rancher-minimal

### Download Cert Manager Images
### https://github.com/cert-manager/cert-manager
helm repo add jetstack https://charts.jetstack.io && helm repo update
certManagerImagesMinimal=$(helm template jetstack/cert-manager --version=v${vCertManager} | grep 'image:' | sed 's/"//g' | awk '{ print $2 }' | sed -e "s/^/    - name: /")

### Set Cert-Manager Images Variable
certmanagerImagesMinimal=$(cat cert-manager-images-minimal.txt)

### Download Rancher Images
### https://github.com/rancher/rancher
curl -#L https://github.com/rancher/rancher/releases/download/v${vRancher}/rancher-images.txt -o rancher-images-minimal.txt

sed -i '/neuvector\|minio\|gke\|aks\|eks\|sriov\|harvester\|longhorn\|thanos\|tekton\|istio\|multus\|hyper\|jenkins\|prom\|grafana\|windows/d' rancher-images-minimal.txt

awk -F: '{print $1}' rancher-images-minimal.txt | while read -r i; do
  grep -w "$i" rancher-images-minimal.txt | sort -Vr | head -1 >> rancher-images-minimal-unsorted.txt
done

sort -u rancher-images-minimal-unsorted.txt > rancher-images-minimal.txt
sed -i "s/^/    - name: /" rancher-images-minimal.txt

### Set Rancher Images Variable
rancherImagesMinimal=$(cat rancher-images-minimal.txt)

### Create Hauler Manifest
cat << EOF >> /opt/hauler/rancher-minimal/rancher-airgap-rancher-minimal.yaml
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
      version: v${vCertManager}
    - name: rancher
      repoURL: https://releases.rancher.com/server-charts/latest
      version: ${vRancher}
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Images
metadata:
  name: rancher-airgap-cert-manager-images-rancher-minimal
spec:
  images:
${certManagerImagesMinimal}
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Images
metadata:
  name: rancher-airgap-rancher-images-rancher-minimal
spec:
  images:
${rancherImagesMinimal}
EOF

### Add the Hauler Manifest
hauler store add file rancher-airgap-rancher-minimal.yaml
