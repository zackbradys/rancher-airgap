## Internet Connected Server

Complete the following commands on the Internet Connected Server. For the initial airgap, we recommend you bring all components over the airgap and then individual components as required in the future.

```bash
### Set Variables
export vRancherAirgap=0.7.0

### Fetch Individual Hauler TARs
mkdir -p /opt/rancher/hauler
cd /opt/rancher/hauler

curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/hauler/rancher-airgap-hauler.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/rke2/rancher-airgap-rke2.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/rancher/rancher-airgap-rancher.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/longhorn/rancher-airgap-longhorn.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/neuvector/rancher-airgap-neuvector.tar.zst

### Optional: Create Single Hauler TAR
tar -czvf /opt/rancher/hauler/rancher-airgap.tar.zst .
```

---

**MOVE TAR(s) ACROSS THE AIRGAP**

---

## Disconnected Server

Complete the following commands on the Disconnected Server. We recommend you do **not** use this server as one of the nodes in the cluster.

### Setup Server with Hauler
```bash
### Install OS Packages
### There are many ways to airgap packages, please refer to other guides.
yum install -y zip zstd tree jq iptables container-selinux iptables libnetfilter_conntrack libnfnetlink libnftnl policycoreutils-python-utils cryptsetup
yum install -y nfs-utils && yum install -y iscsi-initiator-utils && echo "InitiatorName=$(/sbin/iscsi-iname)" > /etc/iscsi/initiatorname.iscsi && systemctl enable --now iscsid
echo -e "[keyfile]\nunmanaged-devices=interface-name:cali*;interface-name:flannel*" > /etc/NetworkManager/conf.d/rke2-canal.conf

### Setup Directories
mkdir -p /opt/rancher/hauler
cd /opt/rancher/hauler

### Untar Hauler
tar -xf /opt/rancher/hauler/rancher-airgap-hauler.tar.zst
rm -rf rancher-airgap-hauler.tar.zst && cp hauler /usr/bin/hauler

### Verify Hauler Store
hauler store info

### Import Hauler TARs (will take a minute)
hauler store load rancher-airgap-rke2.tar.zst rancher-airgap-rancher.tar.zst rancher-airgap-longhorn.tar.zst rancher-airgap-neuvector.tar.zst

### Verify Hauler Store
hauler store info

### Create Hauler Registry Directory Structure (will show errors)
hauler store serve

### Serve Hauler Registry (serves the oci compliant registry)
hauler server registry -r registry

### Verify Registry Contents
curl -X GET localhost:5000/v2/_catalog
```

WIP WIP WIP