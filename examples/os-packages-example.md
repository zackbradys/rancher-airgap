## Internet Connected Build Server

Complete the following commands on the Internet Connected Server. For the initial airgap, we recommend you bring all packages over the airgap and then individual packages as required in the future.

```bash
### Setup Package Directory
mkdir -p /opt/rancher/rancher-airgap-packages
cd /opt/rancher/rancher-airgap-packages

### Download Required Packages
### https://github.com/rpm-software-management/createrepo
repotrack git zip zstd tree createrepo container-selinux iptables libnetfilter_conntrack libnfnetlink libnftnl policycoreutils-python-utils cryptsetup iscsi-initiator-utils nfs-utils

### Compile Package List
ls /opt/rancher/rancher-airgap-packages > /opt/rancher/rancher-airgap-packages/packages.txt

### Compress Packages
tar -czvf /opt/rancher/rancher-airgap-packages.tar.zst /opt/rancher/rancher-airgap-packages
cd /opt/rancher && rm -rf /opt/rancher/rancher-airgap-packages
```

---

**MOVE TAR(s) ACROSS THE AIRGAP**

---

## Disconnected Build Server

Complete the following commands on the Disconnected Server. We recommend to **not** use this server in the cluster.

```bash
### Setup Package Directory
mkdir -p /opt/rancher/rancher-airgap-packages
cd /opt/rancher/rancher-airgap-packages

### Untar Packages
tar -xf /opt/rancher/rancher-airgap-packages/rancher-airgap-packages.tar.zst

### Install Packages
rpm -ivh *.rpm
```