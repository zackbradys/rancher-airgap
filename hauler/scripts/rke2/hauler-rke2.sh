### Set Variables
export vRKE2=1.28.11
export vRKE2SELinux=0.18

### Setup Working Directory
rm -rf /opt/hauler/rke2
mkdir -p /opt/hauler/rke2
cd /opt/hauler/rke2

### Download RKE2 Images and Modify the List
### https://github.com/rancher/rke2
rke2Images=$(curl -sSfL https://github.com/rancher/rke2/releases/download/v${vRKE2}+rke2r1/rke2-images-all.linux-amd64.txt | sed -e "s/docker\.io\///g" -e "s/^/    - name: /")

### Create Hauler Manifest
cat << EOF >> /opt/hauler/rke2/rancher-airgap-rke2.yaml
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
    - path: https://github.com/rancher/rke2/releases/download/v${vRKE2}%2Brke2r1/rke2.linux-amd64
      name: rke2.linux-amd64
    - path: https://raw.githubusercontent.com/rancher/rke2/master/install.sh
      name: install.sh
    - path: https://github.com/rancher/rke2-selinux/releases/download/v${vRKE2SELinux}.stable.1/rke2-selinux-${vRKE2SELinux}-1.el9.noarch.rpm
      name: rke2-selinux-${vRKE2SELinux}-1.el9.noarch.rpm
    - path: https://github.com/rancher/rke2-selinux/releases/download/v${vRKE2SELinux}.stable.1/rke2-selinux-${vRKE2SELinux}-1.el8.noarch.rpm
      name: rke2-selinux-${vRKE2SELinux}-1.el8.noarch.rpm
    - path: https://github.com/rancher/rke2-selinux/releases/download/v${vRKE2SELinux}.stable.1/rke2-selinux-${vRKE2SELinux}-1.el7.noarch.rpm
      name: rke2-selinux-${vRKE2SELinux}-1.el7.noarch.rpm
    - path: https://github.com/rancher/rke2-packaging/releases/download/v${vRKE2}%2Brke2r1.stable.0/rke2-common-${vRKE2}.rke2r1-0.el9.x86_64.rpm
      name: rke2-common-${vRKE2}.rke2r1-0.el9.x86_64.rpm
    - path: https://github.com/rancher/rke2-packaging/releases/download/v${vRKE2}%2Brke2r1.stable.0/rke2-common-${vRKE2}.rke2r1-0.el8.x86_64.rpm
      name: rke2-common-${vRKE2}.rke2r1-0.el8.x86_64.rpm
    - path: https://github.com/rancher/rke2-packaging/releases/download/v${vRKE2}%2Brke2r1.stable.0/rke2-common-${vRKE2}.rke2r1-0.el7.x86_64.rpm
      name: rke2-common-${vRKE2}.rke2r1-0.el7.x86_64.rpm
    - path: https://github.com/rancher/rke2-packaging/releases/download/v${vRKE2}%2Brke2r1.stable.0/rke2-server-${vRKE2}.rke2r1-0.el9.x86_64.rpm
      name: rke2-server-${vRKE2}.rke2r1-0.el9.x86_64.rpm
    - path: https://github.com/rancher/rke2-packaging/releases/download/v${vRKE2}%2Brke2r1.stable.0/rke2-server-${vRKE2}.rke2r1-0.el8.x86_64.rpm
      name: rke2-server-${vRKE2}.rke2r1-0.el8.x86_64.rpm
    - path: https://github.com/rancher/rke2-packaging/releases/download/v${vRKE2}%2Brke2r1.stable.0/rke2-server-${vRKE2}.rke2r1-0.el7.x86_64.rpm
      name: rke2-server-${vRKE2}.rke2r1-0.el7.x86_64.rpm
    - path: https://github.com/rancher/rke2-packaging/releases/download/v${vRKE2}%2Brke2r1.stable.0/rke2-agent-${vRKE2}.rke2r1-0.el9.x86_64.rpm
      name: rke2-agent-${vRKE2}.rke2r1-0.el9.x86_64.rpm
    - path: https://github.com/rancher/rke2-packaging/releases/download/v${vRKE2}%2Brke2r1.stable.0/rke2-agent-${vRKE2}.rke2r1-0.el8.x86_64.rpm
      name: rke2-agent-${vRKE2}.rke2r1-0.el8.x86_64.rpm
    - path: https://github.com/rancher/rke2-packaging/releases/download/v${vRKE2}%2Brke2r1.stable.0/rke2-agent-${vRKE2}.rke2r1-0.el7.x86_64.rpm
      name: rke2-agent-${vRKE2}.rke2r1-0.el7.x86_64.rpm
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Images
metadata:
  name: rancher-airgap-images-rke2
spec:
  images:
${rke2Images}
EOF

### Add the Hauler Manifest
hauler store add file rancher-airgap-rke2.yaml
