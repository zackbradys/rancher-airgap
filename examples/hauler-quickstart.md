# Rancher Airgap - Hauler Quickstart

## Internet Connected Build Server
Using Hauler Manifests (generated using Rancher Airgap):
```bash
### Set Variables
export vRancherAirgap=v1.6.3

### Setup Directories
mkdir -p /opt/rancher/hauler
cd /opt/rancher/hauler

### Download and Install Hauler
curl -sfL https://get.hauler.dev | bash

### Fetch Rancher Airgap Manifests
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/hauler/rancher-airgap-hauler.yaml
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/helm/rancher-airgap-helm.yaml
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/cosign/rancher-airgap-cosign.yaml
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/rke2/rancher-airgap-rke2.yaml
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/rancher/rancher-airgap-rancher.yaml
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/longhorn/rancher-airgap-longhorn.yaml
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/neuvector/rancher-airgap-neuvector.yaml
# curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/harbor/rancher-airgap-harbor.yaml
# curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/harvester/rancher-airgap-harvester.yaml

### Sync Manifests to Hauler Store
hauler store sync -f rancher-airgap-hauler.yaml
hauler store sync -f rancher-airgap-helm.yaml
hauler store sync -f rancher-airgap-cosign.yaml
hauler store sync -f rancher-airgap-rke2.yaml
hauler store sync -f rancher-airgap-rancher.yaml
hauler store sync -f rancher-airgap-longhorn.yaml
hauler store sync -f rancher-airgap-neuvector.yaml
# hauler store sync -f rancher-airgap-harbor.yaml
# hauler store sync -f rancher-airgap-harvester.yaml

### Verify Hauler Store
hauler store info

### Compress Hauler Store Contents
hauler store save --filename rancher-airgap.tar.zst
```

Using Rancher Airgaps Tarballs (complied from the manifests):
```bash
### Set Variables
export vRancherAirgap=v1.6.3

### Setup Directories
mkdir -p /opt/rancher/hauler
cd /opt/rancher/hauler

### Download and Install Hauler
curl -sfL https://get.hauler.dev | bash

### Fetch Rancher Airgap Tarballs
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/hauler/rancher-airgap-hauler.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/helm/rancher-airgap-helm.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/cosign/rancher-airgap-cosign.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/rke2/rancher-airgap-rke2.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/rancher/rancher-airgap-rancher.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/longhorn/rancher-airgap-longhorn.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/neuvector/rancher-airgap-neuvector.tar.zst
# curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/harbor/rancher-airgap-harbor.tar.zst
# curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/harvester/rancher-airgap-harvester.tar.zst

### Optional: Create Single TAR
tar -czvf /opt/rancher/hauler/rancher-airgap.tar.zst .
```

---

**MOVE TAR(s) ACROSS THE AIRGAP**

---

## Disconnected Build Server
```bash
### Setup Directories
mkdir -p /opt/rancher/hauler
cd /opt/rancher/hauler

### Untar and Install Hauler
tar -xf /opt/rancher/hauler/rancher-airgap-hauler.tar.zst
rm -rf README.md hauler_0.4.2_linux_amd64.tar.gz && mv hauler /usr/bin/hauler

### Import Hauler TARs (will take a minute)
hauler store load rancher-airgap-helm.tar.zst rancher-airgap-cosign.tar.zst rancher-airgap-rke2.tar.zst rancher-airgap-rancher.tar.zst rancher-airgap-longhorn.tar.zst rancher-airgap-neuvector.tar.zst # rancher-airgap-harbor.tar.zst # rancher-airgap-harvester.tar.zst

### Verify Hauler Store
hauler store info