## Prerequisites

In this example and tutorial, we will **not be covering the specifics about configuring and installing each of the Rancher products**. You should have basic understanding of the Rancher products, before trying to configure and install in a disconnected environment. If you would like to learn more, please take a look at an effortless deployment and installation guide for Rancher RKE2, Rancher Manager, Longhorn, and NeuVector: **https://github.com/zackbradys/rancher-effortless (Video: https://youtu.be/P65r2ODNlTg)!**

## Internet Connected Build Server

Complete the following commands on the Internet Connected Server. For the initial airgap, we recommend you bring all components over the airgap and then individual components as required in the future.

```bash
### Set Variables
export vRancherAirgap=v2.0.0

### Fetch Individual Hauler TARs
mkdir -p /opt/rancher/hauler
cd /opt/rancher/hauler

curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/hauler/rancher-airgap-hauler.tar.zst
curl -#OL https://rancher-airgap.s3.amazonaws.com/${vRancherAirgap}/hauler/rke2/rancher-airgap-rke2.tar.zst

### Optional: Create Single TAR
tar -czvf /opt/rancher/hauler/rancher-airgap.tar.zst .
```

---

**MOVE TAR(s) ACROSS THE AIRGAP**

---

## Disconnected Build Server

Complete the following commands on the Disconnected Server. We recommend to **not** use this server in the cluster.

**Note:** There are many ways to airgap packages, most customers use existing processes or methodologies for it. If you do not currently have a process or method... we have a very simple example over here --> [os packages example readme](os-packages-example.md).

### Setup Server with Hauler
```bash
### Sudo to Root User
sudo su

### Setup Directories
mkdir -p /opt/rancher/hauler
cd /opt/rancher/hauler

### Untar and Install Hauler
tar -xf /opt/rancher/hauler/rancher-airgap-hauler.tar.zst
rm -rf README.md hauler_0.4.2_linux_amd64.tar.gz && mv hauler /usr/bin/hauler

### Import Hauler TARs (will take a minute)
hauler store load rancher-airgap-hauler.tar.zst rancher-airgap-rke2.tar.zst

### Verify Hauler Store
hauler store info

### Serve Hauler Registry (serves the oci compliant registry)
hauler serve registry
```

### Rancher RKE2 Nodes

#### RKE2 Server Node (Control Plane Node)

Complete the following commands on the server node(s) in the cluster. You will need connectivity to the Disconnected Build Server.

```bash
### Set Variables
export vRKE2=1.26.13
export vPlatform=el9
export IP=0.0.0.0

### Sudo to Root User
sudo su

### Verify Registry Contents
curl -X GET $IP:5000/v2/_catalog

### Install OS Packages
yum install -y zip zstd tree jq iptables container-selinux libnetfilter_conntrack libnfnetlink libnftnl policycoreutils-python-utils cryptsetup
yum install -y nfs-utils && yum install -y iscsi-initiator-utils && echo "InitiatorName=$(/sbin/iscsi-iname)" > /etc/iscsi/initiatorname.iscsi && systemctl enable --now iscsid

### Modify NetworkManager
echo -e "[keyfile]\nunmanaged-devices=interface-name:cali*;interface-name:flannel*" > /etc/NetworkManager/conf.d/rke2-canal.conf

### Setup Directories
mkdir -p /etc/rancher/rke2
cd /opt/rancher/hauler

### Extract RKE2 Contents from Hauler Build Server
hauler store extract hauler/rke2-selinux-0.16-1.${vPlatform}.noarch.rpm:latest
hauler store extract hauler/rke2-common-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm:latest
hauler store extract hauler/rke2-server-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm:latest
### Move Extracted Contents to Node

### Install RKE2 SELinux Package
yum install -y rke2-selinux-0.16-1.${vPlatform}.noarch.rpm rke2-common-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm rke2-server-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm

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

### Symlink kubectl and containerd binaries
sudo ln -s /var/lib/rancher/rke2/data/v1*/bin/kubectl /usr/bin/kubectl
sudo ln -s /var/run/k3s/containerd/containerd.sock /var/run/containerd/containerd.sock

### Update and Source BASHRC
cat << EOF >> ~/.bashrc
export PATH=$PATH:/var/lib/rancher/rke2/bin:/usr/local/bin/
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
export CRI_CONFIG_FILE=/var/lib/rancher/rke2/agent/etc/crictl.yaml
alias k=kubectl
EOF

### Verify Node
kubectl get nodes
```

#### RKE2 Agent Nodes (Worker Nodes)

Complete the following commands on the agent node(s) in the cluster. You will need network connectivity to the Disconnected Build Server.

```bash
### Set Variables
export vRKE2=1.26.13
export vPlatform=el9
export IP=0.0.0.0

### Sudo to Root User
sudo su

### Verify Registry Contents
curl -X GET $IP:5000/v2/_catalog

### Setup Directories
mkdir -p /etc/rancher/rke2
cd /opt/rancher/hauler

### Extract RKE2 Contents from Hauler Build Server
hauler store extract hauler/rke2-selinux-0.16-1.${vPlatform}.noarch.rpm:latest
hauler store extract hauler/rke2-common-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm:latest
hauler store extract hauler/rke2-agent-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm:latest
### Move Extracted Contents to Node

### Install RKE2 SELinux Package
yum install -y rke2-selinux-0.16-1.${vPlatform}.noarch.rpm rke2-common-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm rke2-agent-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm

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