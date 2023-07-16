### Set Variables
export vHauler=0.3.0
export vHelm=3.12.0
export vCosign=1.8.0

## Setup Working Directory
mkdir -p /opt/rancher/hauler
cd /opt/rancher/hauler

### Setup Hauler Directory
mkdir -p /opt/rancher/hauler/hauler
cd /opt/rancher/hauler/hauler

### Install Hauler
### https://github.com/rancherfederal/hauler
curl -#OL https://github.com/rancherfederal/hauler/releases/download/v${vHauler}/hauler_${vHauler}_linux_amd64.tar.gz
tar -xf hauler_${vHauler}_linux_amd64.tar.gz
cp hauler /usr/bin/hauler

### Setup Helm Directory
mkdir -p /opt/rancher/hauler/helm
cd /opt/rancher/hauler/helm

### Install Helm
### https://github.com/helm/helm
curl -#OL https://get.helm.sh/helm-v${vHelm}-linux-amd64.tar.gz
tar -zxvf helm-v${vHelm}-linux-amd64.tar.gz linux-amd64/helm && mv linux-amd64/helm /opt/rancher/hauler/helm && rm -rf linux-amd64
cp helm /usr/bin/helm

### Setup Cosign Directory
mkdir -p /opt/rancher/hauler/cosign
cd /opt/rancher/hauler/cosign

### Install Cosign
### https://github.com/sigstore/cosign
curl -#OL https://github.com/sigstore/cosign/releases/download/v${vCosign}/cosign-linux-amd64
mv cosign-linux-amd64 cosign && cp cosign /usr/bin/cosign

### Create Package Directory
mkdir -p /opt/rancher/hauler/rancher-airgap-packages
cd /opt/rancher/hauler/rancher-airgap-packages

### Download Required Packages
### https://github.com/rpm-software-management/createrepo
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
repotrack -y zip zstd skopeo createrepo tree container-selinux iptables libnetfilter_conntrack libnfnetlink libnftnl policycoreutils-python-utils cryptsetup iscsi-initiator-utils nfs-utils

### Set OS Release Variable
export OS=$(. /etc/os-release && echo "$ID"-"$PLATFORM_ID" | sed "s#platform:##")

### Compress Packages
tar -czvf /opt/rancher/hauler/rancher-airgap-packages-${OS}.tar.zst /opt/rancher/hauler/rancher-airgap-packages
cd /opt/rancher/hauler && rm -rf /opt/rancher/hauler/rancher-airgap-packages

### Create Hauler Manifest
cat << EOF >> /opt/rancher/hauler/rancher-airgap.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Files
metadata:
  name: rancher-airgap-files
spec:
  files:
    - path: /opt/rancher/hauler/hauler/hauler
      name: hauler
    - path: /opt/rancher/hauler/helm/helm
      name: helm
    - path: /opt/rancher/hauler/cosign/cosign
      name: cosign
    - path: /opt/rancher/hauler/rancher-airgap-packages-${OS}.tar.zst
      name: rancher-airgap-packages
EOF

### Load Hauler Manifest into Store
hauler store sync -f rancher-airgap-${OS}.yaml

### Verify Hauler Store Contents
hauler store info

### Compress Hauler Store Contents
hauler store save --filename rancher-airgap-${OS}.tar.zst
rm -rf /opt/rancher/hauler/store /opt/rancher/hauler/hauler /opt/rancher/hauler/helm /opt/rancher/hauler/cosign