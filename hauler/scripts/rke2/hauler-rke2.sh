### Set Variables
export vRKE2=1.25.12

### Setup Working Directory
rm -rf /opt/rancher/hauler/rke2
mkdir -p /opt/rancher/hauler/rke2
cd /opt/rancher/hauler/rke2

### Download RKE2 Images
### https://github.com/rancher/rke2
curl -#L https://github.com/rancher/rke2/releases/download/v${vRKE2}+rke2r1/rke2-images-all.linux-amd64.txt -o rke2-images.txt
sed -i "s#^#    - name: #" rke2-images.txt

### Set RKE2 Images Variable
rke2Images=$(cat rke2-images.txt)
rm -rf /opt/rancher/hauler/rke2/rke2-images.txt

### Create Hauler Manifest
cat << EOF >> /opt/rancher/hauler/rke2/rancher-airgap-rke2.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Files
metadata:
  name: rancher-airgap-files-rke2
spec:
  files:
    - path: https://github.com/rancher/rke2/releases/download/v${vRKE2}%2Brke2r1/rke2-images.linux-amd64.tar.zst
      name: rke2-images.linux-amd64.tar.zst
    - path: https://github.com/rancher/rke2/releases/download/v${vRKE2}%2Brke2r1/rke2.linux-amd64.tar.gz
      name: rke2.linux-amd64.tar.gz
    - path: https://github.com/rancher/rke2/releases/download/v${vRKE2}%2Brke2r1/sha256sum-amd64.txt
      name: sha256sum-amd64.txt
    - path: https://github.com/rancher/rke2-packaging/releases/download/v${vRKE2}%2Brke2r1.stable.0/rke2-common-${vRKE2}.rke2r1-0.x86_64.rpm
      name: rke2-common-${vRKE2}.rke2r1-0.x86_64.rpm
    - path: https://github.com/rancher/rke2-selinux/releases/download/v0.14.stable.1/rke2-selinux-0.14-1.el9.noarch.rpm
      name: rke2-selinux-0.14-1.el9.noarch.rpm
    - path: https://github.com/rancher/rke2-selinux/releases/download/v0.14.stable.1/rke2-selinux-0.14-1.el8.noarch.rpm
      name: rke2-selinux-0.14-1.el8.noarch.rpm
    - path: https://github.com/rancher/rke2-selinux/releases/download/v0.14.stable.1/rke2-selinux-0.14-1.el7.noarch.rpm
      name: rke2-selinux-0.14-1.el7.noarch.rpm
    - path: https://raw.githubusercontent.com/rancher/rke2/master/install.sh
      name: install.sh
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Images
metadata:
  name: rancher-airgap-images-rke2
spec:
  images:
${rke2Images}
EOF

### Load Hauler Manifest into Store
hauler store sync -f rancher-airgap-rke2.yaml

### Verify Hauler Store Contents
hauler store info

### Compress Hauler Store Contents
hauler store save --filename rancher-airgap-rke2.tar.zst
rm -rf /opt/rancher/hauler/rke2/store