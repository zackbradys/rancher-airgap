## Internet Connected Server

```bash
### Set Variables
export vRancherAirgap=0.6.1

### Fetch Hauler TARs
mkdir -p /opt/rancher/hauler
cd /opt/rancher/hauler
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/hauler/rancher-airgap-hauler.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/rke2/rancher-airgap-rke2.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/rancher/rancher-airgap-rancher.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/longhorn/rancher-airgap-longhorn.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/neuvector/rancher-airgap-neuvector.tar.zst
```

```bash
### Compress Repo and Hauler TARs
tar -czvf /opt/rancher/hauler/rancher-airgap-$(date +"%Y%d%m").tar.zst /opt/rancher
```

---

**MOVE SINGLE TARBALL ACROSS THE AIRGAP**

---

## Disconnected Server

```bash
### Verify Hauler Store
hauler store info

### Import Hauler TARs (will take a minute)
hauler store load rancher-airgap-base-rocky-el9.tar.zst rancher-airgap-rke2.tar.zst rancher-airgap-rancher.tar.zst rancher-airgap-longhorn.tar.zst rancher-airgap-neuvector.tar.zst
```

```bash
### Verify Hauler Store
hauler store info
```