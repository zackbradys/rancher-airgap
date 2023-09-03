## Internet Connected Build Server

Complete the following commands on the Internet Connected Server. For the initial airgap, we recommend you bring all components over the airgap and then individual components as required in the future.

```bash
### Set Variables
export vRancherAirgap=0.8.1

### Fetch Individual Hauler TARs
mkdir -p /opt/rancher/hauler
cd /opt/rancher/hauler

curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/hauler/rancher-airgap-hauler.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/helm/rancher-airgap-helm.tar.zst
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

## Disconnected Build Server

Complete the following commands on the Disconnected Server. We recommend to **not** use this server in the cluster.

**Note:** There are many ways to airgap packages, most customers use existing processes or methodologies for it. If you do not currently have a process or method... we have a example over here --> [os packages example readme](os-packages-example.md).

### Setup Server with Hauler
```bash
### Setup Directories
mkdir -p /opt/rancher/hauler
cd /opt/rancher/hauler

### Untar and Install Hauler
tar -xf /opt/rancher/hauler/rancher-airgap-hauler.tar.zst
rm -rf README.md hauler_0.3.0_linux_amd64.tar.gz && mv hauler /usr/bin/hauler

### Untar and Install Helm
tar -xf /opt/rancher/hauler/rancher-airgap-helm.tar.zst
rm -rf README.md LICENSE helm-v3.12.0-linux-amd64.tar.gz && mv helm /usr/bin/helm

### Import Hauler TARs (will take a minute)
hauler store load rancher-airgap-rke2.tar.zst rancher-airgap-rancher.tar.zst rancher-airgap-longhorn.tar.zst rancher-airgap-neuvector.tar.zst

### Verify Hauler Store
hauler store info

### Create Hauler Registry Directory Structure (will take a minute and show errors)
hauler store serve

### Serve Hauler Registry (serves the oci compliant registry)
hauler serve registry -r registry
```

### Rancher RKE2 Nodes

#### Rancher RKE2 Server Node (Control Plane)

Complete the following commands on the **first** node in the cluster. You will need network connectivity to the Disconnected Build Server.

```bash
### Set Variables
export vRKE2=1.25.12
export vPlatform=el9
export IP=0.0.0.0

### Verify Registry Contents
curl -X GET $IP:5000/v2/_catalog

### Install OS Packages
yum install -y zip zstd tree jq iptables container-selinux iptables libnetfilter_conntrack libnfnetlink libnftnl policycoreutils-python-utils cryptsetup
yum install -y nfs-utils && yum install -y iscsi-initiator-utils && echo "InitiatorName=$(/sbin/iscsi-iname)" > /etc/iscsi/initiatorname.iscsi && systemctl enable --now iscsid

### Modify NetworkManager
echo -e "[keyfile]\nunmanaged-devices=interface-name:cali*;interface-name:flannel*" > /etc/NetworkManager/conf.d/rke2-canal.conf

### Setup Directories
mkdir -p /etc/rancher/rke2
cd /opt/rancher/hauler

### Extract RKE2 Contents from Hauler Build Server
hauler store extract hauler/rke2-selinux-0.14-1.${vPlatform}.noarch.rpm:latest
hauler store extract hauler/rke2-common-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm:latest
hauler store extract hauler/rke2-server-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm:latest
### Move Extracted Contents to Node

### Install RKE2 SELinux Package
yum install -y rke2-selinux-0.14-1.${vPlatform}.noarch.rpm rke2-common-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm rke2-server-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm

### Configure RKE2 Config
cat << EOF >> /etc/rancher/rke2/config.yaml
token: RancherAirgapRKE2token
system-default-registry: $IP:5000
EOF

### Configure Local Registry
cat << EOF >> /etc/rancher/rke2/registries.yaml
mirrors:
  "$IP:5000":
    endpoint:
      - "http://$IP:5000"
  "docker.io":
    endpoint:
      - "http://$IP:5000"
EOF

### Enable/Start RKE2 Server
systemctl enable --now rke2-server.service

### Symlink kubectl and containerd
sudo ln -s /var/lib/rancher/rke2/data/v1*/bin/kubectl /usr/bin/kubectl
sudo ln -s /var/run/k3s/containerd/containerd.sock /var/run/containerd/containerd.sock

### Update BASHRC with KUBECONFIG/PATH
cat << EOF >> ~/.bashrc
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
export PATH=$PATH:/var/lib/rancher/rke2/bin:/usr/local/bin/
EOF

### Source BASHRC
source ~/.bashrc

### Verify Node
kubectl get nodes
```

#### Rancher RKE2 Agent Nodes (Workers)

Complete the following commands on the **second** and **third** nodes in the cluster. You will need network connectivity to the Disconnected Build Server.

```bash
### Set Variables
export vRKE2=1.25.12
export vPlatform=el9
export IP=0.0.0.0

### Verify Registry Contents
curl -X GET $IP:5000/v2/_catalog

### Setup Directories
mkdir -p /etc/rancher/rke2
cd /opt/rancher/hauler

### Extract RKE2 Contents from Hauler Build Server
hauler store extract hauler/rke2-selinux-0.14-1.${vPlatform}.noarch.rpm:latest
hauler store extract hauler/rke2-common-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm:latest
hauler store extract hauler/rke2-agent-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm:latest
### Move Extracted Contents to Node

### Install RKE2 SELinux Package
yum install -y rke2-selinux-0.14-1.${vPlatform}.noarch.rpm rke2-common-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm rke2-agent-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm

### Configure RKE2 Config
cat << EOF >> /etc/rancher/rke2/config.yaml
server: https://$IP:9345
token: RancherAirgapRKE2token
system-default-registry: $IP:5000
EOF

### Configure Local Registry
cat << EOF >> /etc/rancher/rke2/registries.yaml
mirrors:
  "$IP:5000":
    endpoint:
      - "http://$IP:5000"
  "docker.io":
    endpoint:
      - "http://$IP:5000"
EOF

### Enable/Start RKE2 Agent
systemctl enable --now rke2-agent.service
```