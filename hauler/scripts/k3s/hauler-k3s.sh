# Set Variables
export vK3S=1.32.7
export vK3SSELinux=1.6
export vK3Smodified=$(echo "$vK3S" | cut -d'.' -f1,2)

# Setup Working Directory
rm -rf /opt/hauler/k3s
mkdir -p /opt/hauler/k3s
cd /opt/hauler/k3s

# Download K3S Images and Modify the List
# https://github.com/k3s-io/k3s
k3sImages=$(curl -sSfL https://github.com/k3s-io/k3s/releases/download/v${vK3S}+k3s1/k3s-images.txt | sed -e "s/docker\.io\///g" -e "s/^/    - name: /")

# Create Hauler Manifest
cat << EOF >> /opt/hauler/k3s/rancher-airgap-k3s.yaml
apiVersion: content.hauler.cattle.io/v1
kind: Files
metadata:
  name: rancher-airgap-files-k3s
spec:
  files:
    - path: https://raw.githubusercontent.com/k3s-io/k3s/refs/heads/release-${vK3Smodified}/install.sh
      name: install.sh
    - path: https://github.com/k3s-io/k3s/releases/download/v${vK3S}%2Bk3s1/k3s
      name: k3s
    - path: https://github.com/k3s-io/k3s/releases/download/v${vK3S}%2Bk3s1/k3s-airgap-images-amd64.tar.zst
      name: k3s-airgap-images-amd64.tar.zst
    - path: https://github.com/k3s-io/k3s/releases/download/v${vK3S}%2Bk3s1/sha256sum-amd64.txt
      name: sha256sum-amd64.txt
    - path: https://github.com/k3s-io/k3s/releases/download/v${vK3S}%2Bk3s1/k3s-airgap-images-arm64.tar.zst
      name: k3s-airgap-images-arm64.tar.zst
    - path: https://github.com/k3s-io/k3s/releases/download/v${vK3S}%2Bk3s1/sha256sum-arm64.txt
      name: sha256sum-arm64.txt
    - path: https://github.com/k3s-io/k3s/releases/download/v${vK3S}%2Bk3s1/k3s-arm64
      name: k3s-arm64
    - path: https://github.com/k3s-io/k3s-selinux/releases/download/v${vK3SSELinux}.latest.1/k3s-selinux-${vK3SSELinux}-1.el9.noarch.rpm
      name: k3s-selinux-${vK3SSELinux}-1.el9.noarch.rpm
    - path: https://github.com/k3s-io/k3s-selinux/releases/download/v${vK3SSELinux}.latest.1/k3s-selinux-${vK3SSELinux}-1.el9.noarch.rpm
      name: k3s-selinux-${vK3SSELinux}-1.el8.noarch.rpm
    - path: https://github.com/k3s-io/k3s-selinux/releases/download/v${vK3SSELinux}.latest.1/k3s-selinux-${vK3SSELinux}-1.el9.noarch.rpm
      name: k3s-selinux-${vK3SSELinux}-1.el7.noarch.rpm
---
apiVersion: content.hauler.cattle.io/v1
kind: Images
metadata:
  name: rancher-airgap-images-k3s
spec:
  images:
${k3sImages}
EOF
