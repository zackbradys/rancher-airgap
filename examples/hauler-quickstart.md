# Rancher Airgap - Hauler Quickstart

## Internet Connected Build Server
```bash
### Set Variables
export vRancherAirgap=v1.4.1

### Fetch Individual Hauler TARs
mkdir -p /opt/rancher/hauler
cd /opt/rancher/hauler

curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/hauler/rancher-airgap-hauler.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/helm/rancher-airgap-helm.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/cosign/rancher-airgap-cosign.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/rke2/rancher-airgap-rke2.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/rancher/rancher-airgap-rancher.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/longhorn/rancher-airgap-longhorn.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/neuvector/rancher-airgap-neuvector.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/harvester/rancher-airgap-harvester.tar.zst

### Optional: Create Single TAR
tar -czvf /opt/rancher/hauler/rancher-airgap.tar.zst .
```

---

**MOVE TAR(s) ACROSS THE AIRGAP**

---

## Disconnected Build Server
```bash
### Sudo to Root User
sudo su

### Setup Directories
mkdir -p /opt/rancher/hauler
cd /opt/rancher/hauler

### Untar and Install Hauler
tar -xf /opt/rancher/hauler/rancher-airgap-hauler.tar.zst
rm -rf README.md hauler_0.3.0_linux_amd64.tar.gz && mv hauler /usr/bin/hauler

### Import Hauler TARs (will take a minute)
hauler store load rancher-airgap-hauler.tar.zst rancher-airgap-helm.tar.zst rancher-airgap-cosign.tar.zst rancher-airgap-rke2.tar.zst rancher-airgap-rancher.tar.zst rancher-airgap-longhorn.tar.zst rancher-airgap-neuvector.tar.zst rancher-airgap-harvester.tar.zst

### Verify Hauler Store
hauler store info