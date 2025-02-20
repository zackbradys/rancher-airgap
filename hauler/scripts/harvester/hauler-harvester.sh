# Set Variables
export vHarvester=1.4.1

# Setup Working Directory
rm -rf /opt/hauler/harvester
mkdir -p /opt/hauler/harvester
cd /opt/hauler/harvester

# Download Harvester Images and Modify the List
# https://github.com/harvester/harvester
harvesterImagesAMD64=$(curl -sSfL https://github.com/harvester/harvester/releases/download/v${vHarvester}/harvester-images-list-amd64.txt | sed -e "/^\s*#/d" -e "/^$/d" -e "s/^/    - name: /" -e "s/docker\.io\///g")

# Download Harvester Images and Modify the List
# https://github.com/harvester/harvester
harvesterImagesARM64=$(curl -sSfL https://github.com/harvester/harvester/releases/download/v${vHarvester}/harvester-images-list-arm64.txt | sed -e "/^\s*#/d" -e "/^$/d" -e "s/^/    - name: /" -e "s/docker\.io\///g")

# Combine Harvester Image Lists
harvesterImages=$(echo -e "${harvesterImagesAMD64}\n${harvesterImagesARM64}" | sort | uniq)

# Create Hauler Manifest
cat << EOF >> /opt/hauler/harvester/rancher-airgap-harvester.yaml
apiVersion: content.hauler.cattle.io/v1
kind: Files
metadata:
  name: rancher-airgap-files-harvester
spec:
  files:
    - path: https://releases.rancher.com/harvester/v${vHarvester}/harvester-v${vHarvester}-amd64.iso
      name: harvester-v${vHarvester}-amd64.iso
    - path: https://releases.rancher.com/harvester/v${vHarvester}/harvester-v${vHarvester}-vmlinuz-amd64
      name: harvester-v${vHarvester}-vmlinuz-amd64
    - path: https://releases.rancher.com/harvester/v${vHarvester}/harvester-v${vHarvester}-initrd-amd64
      name: harvester-v${vHarvester}-initrd-amd64
    - path: https://releases.rancher.com/harvester/v${vHarvester}/harvester-v${vHarvester}-rootfs-amd64.squashfs
      name: harvester-v${vHarvester}-rootfs-amd64.squashfs
    - path: https://releases.rancher.com/harvester/v${vHarvester}/harvester-v${vHarvester}-amd64.sha512
      name: harvester-v${vHarvester}-amd64.sha512
    - path: https://releases.rancher.com/harvester/v${vHarvester}/version.yaml
      name: version.yaml
    - path: https://releases.rancher.com/harvester/v${vHarvester}/harvester-v${vHarvester}-amd64-net-install.iso
      name: harvester-v${vHarvester}-amd64-net-install.iso
    - path: https://releases.rancher.com/harvester/v${vHarvester}/harvester-v${vHarvester}-arm64.iso
      name: harvester-v${vHarvester}-arm64.iso
    - path: https://releases.rancher.com/harvester/v${vHarvester}/harvester-v${vHarvester}-vmlinuz-arm64
      name: harvester-v${vHarvester}-vmlinuz-arm64
    - path: https://releases.rancher.com/harvester/v${vHarvester}/harvester-v${vHarvester}-initrd-arm64
      name: harvester-v${vHarvester}-initrd-arm64
    - path: https://releases.rancher.com/harvester/v${vHarvester}/harvester-v${vHarvester}-rootfs-arm64.squashfs
      name: harvester-v${vHarvester}-rootfs-arm64.squashfs
    - path: https://releases.rancher.com/harvester/v${vHarvester}/harvester-v${vHarvester}-arm64.sha512
      name: harvester-v${vHarvester}-arm64.sha512
    - path: https://releases.rancher.com/harvester/v${vHarvester}/version-arm64.yaml
      name: version-arm64.yaml
    - path: https://releases.rancher.com/harvester/v${vHarvester}/harvester-v${vHarvester}-arm64-net-install.iso
      name: harvester-v${vHarvester}-arm64-net-install.iso
---
apiVersion: content.hauler.cattle.io/v1
kind: Images
metadata:
  name: rancher-airgap-images-harvester
spec:
  images:
${harvesterImages}
EOF
