## Internet Connected Build Server

Complete the following commands on the Internet Connected Server. For the initial airgap, we recommend you bring all packages over the airgap and then individual packages as required in the future.

```bash
# Setup Directories
mkdir -p /opt/hauler
cd /opt/hauler

# Download and Install Hauler
curl -sfL https://get.hauler.dev | bash

# Download and Install createrepo
# https://github.com/rpm-software-management/createrepo
yum install -y createrepo

# Setup Directories
mkdir -p /opt/hauler/repos
cd /opt/hauler/repos

# Download Required Packages
# https://man7.org/linux/man-pages/man1/repotrack.1.html
repotrack iptables container-selinux libnetfilter_conntrack libnfnetlink libnftnl policycoreutils-python-utils cryptsetup nfs-utils iscsi-initiator-utils git zip zstd tree jq createrepo

# Create YUM Repo
cd /opt/hauler
createrepo /opt/hauler/repos

# Compile Package List
find /opt/hauler/repos > /opt/hauler/repos/package-list.txt

# Generate the Hauler Manifest for Packages
cat <<EOF > rancher-airgap-packages.yaml
apiVersion: content.hauler.cattle.io/v1
kind: Files
metadata:
  name: rancher-airgap-packages
spec:
  files:
$(cat /opt/hauler/repos/package-list.txt | sed 's/^/    - path: /')
EOF

# Sync Manifests to Hauler Store
hauler store sync --store packages --filename rancher-airgap-packages.yaml

# Compress Hauler Store Contents
hauler store save --store packages --filename rancher-airgap-packages.tar.zst

# Fetch Hauler Binary
curl -sfOL https://github.com/hauler-dev/hauler/releases/download/v1.2.1/hauler_1.2.1_linux_amd64.tar.gz
```

---

**MOVE TAR(s) ACROSS THE AIRGAP**

---

## Disconnected Build Server

Complete the following commands on the Disconnected Server. We recommend to **not** use this server in the cluster.

```bash
# Setup Directories
mkdir -p /opt/hauler
cd /opt/hauler

# SCP TARBALLS HERE

# Untar and Install Hauler
tar -xf hauler_1.2.1_linux_amd64.tar.gz
rm -rf LICENSE README.md
chmod 755 hauler && mv hauler /usr/bin/hauler

# Load Hauler Tarballs
hauler store load --filename rancher-airgap-packages.tar.zst

# Verify Hauler Store Contents
hauler store info

# Serve Hauler Content
hauler store serve fileserver
# nohup hauler store serve fileserver &

# Verify File Server Content
curl http://<FQDN or IP>:<PORT>

# Create YUM Repo File
cat << EOF > /etc/yum.repos.d/rancher-airgap.repo
[rancher-airgap]
name=Rancher Airgap YUM Repository
baseurl=http://<FQDN or IP>:<PORT>
enabled=1
exactarch=0
gpgcheck=0
EOF

# Disable Default YUM Repos
# useful when simulating airgapped servers
yum-config-manager --disable appstream baseos extras

# List Available YUM Repos
yum repolist all
```