# Set Variables
export vRKE2=1.30.9
export vRKE2SELinux=0.18
export vRKE2modified=$(echo "$vRKE2" | cut -d'.' -f1,2)

# Setup Working Directory
rm -rf /opt/hauler/rke2
mkdir -p /opt/hauler/rke2
cd /opt/hauler/rke2

# Download RKE2 Images and Modify the List
# https://github.com/rancher/rke2
rke2ImagesAMD64=$(curl -sSfL https://github.com/rancher/rke2/releases/download/v${vRKE2}+rke2r1/rke2-images-all.linux-amd64.txt | sed -e "s/docker\.io\///g" -e "s/^/    - name: /")

# Download RKE2 Images and Modify the List
# https://github.com/rancher/rke2
rke2ImagesARM64=$(curl -sSfL https://github.com/rancher/rke2/releases/download/v${vRKE2}+rke2r1/rke2-images-all.linux-arm64.txt | sed -e "s/docker\.io\///g" -e "s/^/    - name: /")

# Combine RKE2 Image Lists
rke2Images=$(echo -e "${rke2ImagesAMD64}\n${rke2ImagesARM64}" | sort | uniq)

# Create Hauler Manifest
cat << EOF >> /opt/hauler/rke2/rancher-airgap-rke2.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Files
metadata:
  name: rancher-airgap-files-rke2
spec:
  files:
    - path: https://raw.githubusercontent.com/rancher/rke2/refs/heads/release-${vRKE2modified}/install.sh
      name: install.sh
    - path: https://github.com/rancher/rke2/releases/download/v${vRKE2}%2Brke2r1/rke2-images.linux-amd64.tar.zst
      name: rke2-images.linux-amd64.tar.zst
    - path: https://github.com/rancher/rke2/releases/download/v${vRKE2}%2Brke2r1/rke2.linux-amd64.tar.gz
      name: rke2.linux-amd64.tar.gz
    - path: https://github.com/rancher/rke2/releases/download/v${vRKE2}%2Brke2r1/sha256sum-amd64.txt
      name: sha256sum-amd64.txt
    - path: https://github.com/rancher/rke2/releases/download/v${vRKE2}%2Brke2r1/rke2.linux-amd64
      name: rke2.linux-amd64
    - path: https://github.com/rancher/rke2/releases/download/v${vRKE2}%2Brke2r1/rke2-images.linux-arm64.tar.zst
      name: rke2-images.linux-arm64.tar.zst
    - path: https://github.com/rancher/rke2/releases/download/v${vRKE2}%2Brke2r1/rke2.linux-arm64.tar.gz
      name: rke2.linux-arm64.tar.gz
    - path: https://github.com/rancher/rke2/releases/download/v${vRKE2}%2Brke2r1/sha256sum-arm64.txt
      name: sha256sum-arm64.txt
    - path: https://github.com/rancher/rke2/releases/download/v${vRKE2}%2Brke2r1/rke2.linux-arm64
      name: rke2.linux-arm64
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
