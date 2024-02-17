### Setup Working Directory
rm -rf /opt/hauler/kubevip
mkdir -p /opt/hauler/kubevip
cd /opt/hauler/kubevip

kubevipImage=$(curl -sL kube-vip.io/k3s | grep -o 'image:.*' | sed 's/image: /    - name: /')

### Create Hauler Manifest
cat << EOF >> /opt/hauler/kubevip/rancher-airgap-kubevip.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Images
metadata:
  name: rancher-airgap-images-kubevip
spec:
  images:
${kubevipImage}
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Files
metadata:
  name: rancher-airgap-files-kubevip
spec:
  files:
    - path: https://kube-vip.io/k3s
      name: kubevip-daemonset-manifest.yaml
    - path: https://kube-vip.io/manifests/rbac.yaml
      name: kubevip-rbac-manifest.yaml
EOF