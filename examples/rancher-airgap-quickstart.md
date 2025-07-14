# Rancher Airgap - Hauler Quickstart

## Internet Connected Build Server

```bash
# Sudo to Root
sudo su

# Setup Directories
mkdir -p /opt/hauler
cd /opt/hauler

# Download and Install Hauler
curl -sfL https://get.hauler.dev | bash

# Fetch Rancher Airgap Manifests
# Optional Assets/Artifacts are Commented Out
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/rke2/rancher-airgap-rke2.yaml
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/k3s/rancher-airgap-k3s.yaml
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/rancher/rancher-airgap-rancher.yaml
# curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/rancher/rancher-airgap-rancher-minimal.yaml
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/longhorn/rancher-airgap-longhorn.yaml
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/neuvector/rancher-airgap-neuvector.yaml
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/harvester/rancher-airgap-harvester.yaml
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/harvester/rancher-airgap-harvester-isos.yaml
# curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/gitea/rancher-airgap-gitea.yaml
# curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/vault/rancher-airgap-vault.yaml
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/kubevip/rancher-airgap-kubevip.yaml
# curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/cosign/rancher-airgap-cosign.yaml
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/hauler/rancher-airgap-hauler.yaml
curl -sfOL https://raw.githubusercontent.com/zackbradys/rancher-airgap/main/hauler/helm/rancher-airgap-helm.yaml

# Sync Manifests to Hauler Store
# Optional Assets/Artifacts are Commented Out
hauler store sync --store rke2-store --platform linux/amd64 --filename hauler/rke2/rancher-airgap-rke2.yaml
# hauler store sync --store k3s-store --platform linux/amd64 --filename hauler/k3s/rancher-airgap-k3s.yaml
hauler store sync --store rancher-store --platform linux/amd64 --filename hauler/rancher/rancher-airgap-rancher.yaml
# hauler store sync --store rancher-store --platform linux/amd64 --filename hauler/rancher/rancher-airgap-rancher-minimal.yaml
hauler store sync --store longhorn-store --platform linux/amd64 --filename hauler/longhorn/rancher-airgap-longhorn.yaml
hauler store sync --store neuvector-store --platform linux/amd64 --filename hauler/neuvector/rancher-airgap-neuvector.yaml
hauler store sync --store harvester-store --platform linux/amd64 --filename hauler/harvester/rancher-airgap-harvester.yaml
hauler store sync --store harvester-store --platform linux/amd64 --filename hauler/harvester/rancher-airgap-harvester-isos.yaml
# hauler store sync --store gitea-store --platform linux/amd64 --filename hauler/gitea/rancher-airgap-gitea.yaml
# hauler store sync --store vault-store --platform linux/amd64 --filename hauler/vault/rancher-airgap-vault.yaml
hauler store sync --store kubevip-store --platform linux/amd64 --filename hauler/kubevip/rancher-airgap-kubevip.yaml
# hauler store sync --store cosign-store --filename hauler/cosign/rancher-airgap-cosign.yaml
hauler store sync --store hauler-store --filename hauler/hauler/rancher-airgap-hauler.yaml
hauler store sync --store helm-store --filename hauler/helm/rancher-airgap-helm.yaml

# Save Hauler Tarballs
# Optional Assets/Artifacts are Commented Out
hauler store save --store rke2-store --filename rancher-airgap-rke2.tar.zst
# hauler store save --store rke2-store --filename rancher-airgap-rke2.tar.zst
hauler store save --store rancher-store --filename rancher-airgap-rancher.tar.zst
# hauler store save --store rancher-store --filename rancher-airgap-rancher-minimal.tar.zst
hauler store save --store longhorn-store --filename rancher-airgap-longhorn.tar.zst
hauler store save --store neuvector-store --filename rancher-airgap-neuvector.tar.zst
hauler store save --store harvester-store --filename rancher-airgap-harvester.tar.zst
hauler store save --store harvester-store --filename rancher-airgap-harvester-isos.tar.zst
# hauler store save --store gitea-store --filename rancher-airgap-gitea.tar.zst
# hauler store save --store vault-store --filename rancher-airgap-vault.tar.zst
hauler store save --store kubevip-store --filename rancher-airgap-kubevip.tar.zst
# hauler store save --store cosign-store --filename rancher-airgap-cosign.tar.zst
hauler store save --store hauler-store --filename rancher-airgap-hauler.tar.zst
hauler store save --store hauler-helm --filename rancher-airgap-helm.tar.zst

# Fetch Hauler Binary
curl -sfOL https://github.com/hauler-dev/hauler/releases/download/v1.2.4/hauler_1.2.4_linux_amd64.tar.gz
# curl -sfOL https://github.com/hauler-dev/hauler/releases/download/v1.2.4/hauler_1.2.4_linux_arm64.tar.gz
# curl -sfOL https://github.com/hauler-dev/hauler/releases/download/v1.2.4/hauler_1.2.4_darwin_amd64.tar.gz
# curl -sfOL https://github.com/hauler-dev/hauler/releases/download/v1.2.4/hauler_1.2.4_darwin_arm64.tar.gz
# curl -sfOL https://github.com/hauler-dev/hauler/releases/download/v1.2.4/hauler_1.2.4_windows_amd64.tar.gz
# curl -sfOL https://github.com/hauler-dev/hauler/releases/download/v1.2.4/hauler_1.2.4_windows_arm64.tar.gz
```

---

**MOVE TARBALLS ACROSS THE AIRGAP**

---

## Disconnected Build Server

```bash
# Sudo to Root
sudo su

# Set Variables
export registry=<FQDN or IP>:5000
export fileserver=<FQDN or IP>:8080

# Setup Directories
mkdir -p /opt/hauler
cd /opt/hauler

# MOVE TARBALLS HERE

# Untar and Install Hauler
tar -xf hauler_1.0.7_linux_amd64.tar.gz
rm -rf LICENSE README.md
chmod 755 hauler && mv hauler /usr/bin/hauler

# Load Hauler Tarballs
hauler store load --filename rancher-airgap-rke2.tar.zst
hauler store load --filename rancher-airgap-rancher.tar.zst
# hauler store load --filename rancher-airgap-rancher-minimal.tar.zst
hauler store load --filename rancher-airgap-longhorn.tar.zst
hauler store load --filename rancher-airgap-neuvector.tar.zst
hauler store load --filename rancher-airgap-harvester.tar.zst
hauler store load --filename rancher-airgap-harvester-isos.tar.zst
# hauler store load --filename rancher-airgap-gitea.tar.zst
# hauler store load --filename rancher-airgap-kubevip.tar.zst
# hauler store load --filename rancher-airgap-cosign.tar.zst
hauler store load --filename rancher-airgap-hauler.tar.zst
hauler store load --filename rancher-airgap-helm.tar.zst

# Verify Hauler Store Contents
hauler store info

# Serve Hauler Content
hauler store serve registry
# nohup hauler store serve registry &
# ps aux | grep hauler
# kill <PID>

# Test Registry Server Content
curl ${registry}/v2/_catalog

# Serve Hauler Content
hauler store serve fileserver
# nohup hauler store serve fileserver &
# ps aux | grep hauler
# kill <PID>

# Test File Server Content
curl http://${fileserver}
```

### Rancher RKE2 Nodes

#### RKE2 Server Node (Control Plane Node)

Complete the following commands on the first server node in the cluster. You will need network connectivity to the Disconnected Build Server.

```bash
# Sudo to Root
sudo su

# Set Variables
export vRKE2=v1.31.10
export vPlatform=el9
export registry=<FQDN or IP>:5000
export fileserver=<FQDN or IP>:8080

# Apply System Settings
cat << EOF >> /etc/sysctl.conf
# Modified System Settings
vm.swappiness=0
vm.panic_on_oom=0
vm.overcommit_memory=1
kernel.panic=10
kernel.panic_on_oops=1
vm.max_map_count = 262144
net.ipv4.ip_local_port_range=1024 65000
net.core.somaxconn=10000
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_fin_timeout=15
net.core.somaxconn=4096
net.core.netdev_max_backlog=4096
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.ipv4.tcp_max_syn_backlog=20480
net.ipv4.tcp_max_tw_buckets=400000
net.ipv4.tcp_no_metrics_save=1
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_syn_retries=2
net.ipv4.tcp_synack_retries=2
net.ipv4.tcp_wmem=4096 65536 16777216
net.ipv4.neigh.default.gc_thresh1=8096
net.ipv4.neigh.default.gc_thresh2=12288
net.ipv4.neigh.default.gc_thresh3=16384
net.ipv4.tcp_keepalive_time=600
net.ipv4.ip_forward=1
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
fs.inotify.max_user_instances=8192
fs.inotify.max_user_watches=1048576
EOF
sysctl -p > /dev/null 2>&1

# Install Packages
yum install -y iptables container-selinux libnetfilter_conntrack libnfnetlink libnftnl policycoreutils-python-utils cryptsetup
yum install -y nfs-utils iscsi-initiator-utils zip zstd tree jq

# Modify Settings
echo "InitiatorName=$(/sbin/iscsi-iname)" > /etc/iscsi/initiatorname.iscsi && systemctl enable --now iscsid
systemctl stop firewalld; systemctl disable firewalld; systemctl stop nm-cloud-setup; systemctl disable nm-cloud-setup; systemctl stop nm-cloud-setup.timer; systemctl disable nm-cloud-setup.timer
echo -e "[keyfile]\nunmanaged-devices=interface-name:cali*;interface-name:flannel*" > /etc/NetworkManager/conf.d/rke2-canal.conf

# Setup Directories
mkdir -p /etc/rancher/rke2

# Configure RKE2 Config
cat << EOF >> /etc/rancher/rke2/config.yaml
token: RancherAirgapRKE2token
system-default-registry: ${registry}
EOF

# Configure Local Registry
cat << EOF >> /etc/rancher/rke2/registries.yaml
mirrors:
  "*":
    endpoint:
      - "http://${registry}"
configs:
  "$Registry":
    tls:
      insecure_skip_verify: true
EOF

# Install Depedencies
yum install -y http://${fileserver}/rke2-selinux-0.18-1.${vPlatform}.noarch.rpm http://${fileserver}/rke2-common-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm http://${fileserver}/rke2-server-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm

# Download and Install RKE2 Server
# curl -sfOL http://${fileserver}/install.sh | INSTALL_RKE2_VERSION=${vRKE2} INSTALL_RKE2_TYPE=server sh -

# Enable and Start RKE2 Server
systemctl enable rke2-server.service && systemctl start rke2-server.service

# Symlink kubectl and containerd binaries
sudo ln -s /var/lib/rancher/rke2/data/v1*/bin/kubectl /usr/bin/kubectl
sudo ln -s /var/run/k3s/containerd/containerd.sock /var/run/containerd/containerd.sock

# Update and Source BASHRC
cat << EOF >> ~/.bashrc
export PATH=$PATH:/var/lib/rancher/rke2/bin:/usr/local/bin/
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
export CRI_CONFIG_FILE=/var/lib/rancher/rke2/agent/etc/crictl.yaml
alias k=kubectl
EOF
source ~/.bashrc

# Verify Node
kubectl get nodes
```

#### RKE2 Agent Nodes (Worker Nodes)

Complete the following commands on the agent node(s) in the cluster. You will need network connectivity to the Disconnected Build Server.

```bash
# Sudo to Root
sudo su

# Set Variables
export vRKE2=v1.31.10
export vPlatform=el9
export registry=<FQDN or IP>:5000
export fileserver=<FQDN or IP>:8080
export serverNode=<FQDN or IP>

# Apply System Settings
cat << EOF >> /etc/sysctl.conf
# Modified System Settings
vm.swappiness=0
vm.panic_on_oom=0
vm.overcommit_memory=1
kernel.panic=10
kernel.panic_on_oops=1
vm.max_map_count = 262144
net.ipv4.ip_local_port_range=1024 65000
net.core.somaxconn=10000
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_fin_timeout=15
net.core.somaxconn=4096
net.core.netdev_max_backlog=4096
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.ipv4.tcp_max_syn_backlog=20480
net.ipv4.tcp_max_tw_buckets=400000
net.ipv4.tcp_no_metrics_save=1
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_syn_retries=2
net.ipv4.tcp_synack_retries=2
net.ipv4.tcp_wmem=4096 65536 16777216
net.ipv4.neigh.default.gc_thresh1=8096
net.ipv4.neigh.default.gc_thresh2=12288
net.ipv4.neigh.default.gc_thresh3=16384
net.ipv4.tcp_keepalive_time=600
net.ipv4.ip_forward=1
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
fs.inotify.max_user_instances=8192
fs.inotify.max_user_watches=1048576
EOF
sysctl -p > /dev/null 2>&1

# Install Packages
yum install -y iptables container-selinux libnetfilter_conntrack libnfnetlink libnftnl policycoreutils-python-utils cryptsetup
yum install -y nfs-utils iscsi-initiator-utils; yum install -y zip zstd tree jq

# Modify Settings
echo "InitiatorName=$(/sbin/iscsi-iname)" > /etc/iscsi/initiatorname.iscsi && systemctl enable --now iscsid
systemctl stop firewalld; systemctl disable firewalld; systemctl stop nm-cloud-setup; systemctl disable nm-cloud-setup; systemctl stop nm-cloud-setup.timer; systemctl disable nm-cloud-setup.timer
echo -e "[keyfile]\nunmanaged-devices=interface-name:cali*;interface-name:flannel*" > /etc/NetworkManager/conf.d/rke2-canal.conf

# Setup Directories
mkdir -p /etc/rancher/rke2

# Configure RKE2 Config
cat << EOF >> /etc/rancher/rke2/config.yaml
server: https://${serverNode}:9345
token: RancherAirgapRKE2token
system-default-registry: ${registry}
EOF

# Configure Local Registry
cat << EOF >> /etc/rancher/rke2/registries.yaml
mirrors:
  "*":
    endpoint:
      - "http://${registry}"
EOF

# Install Depedencies
yum install -y http://${fileserver}/rke2-selinux-0.18-1.${vPlatform}.noarch.rpm http://${fileserver}/rke2-common-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm http://${fileserver}/rke2-agent-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm

# Download and Install RKE2 Server
# curl -sfOL http://${fileserver}/install.sh | INSTALL_RKE2_VERSION=${vRKE2} INSTALL_RKE2_TYPE=agent sh -

# Enable and Start RKE2 Agent
systemctl enable rke2-agent.service && systemctl start rke2-agent.service
```

#### Helm

Complete the following commands on the first server node in the cluster.

```bash
# Sudo to Root
sudo su

# Set Variables
export registry=<FQDN or IP>:5000
export fileserver=<FQDN or IP>:8080

# Fetch the Helm Tarball
curl -sfOL http://${fileserver}/helm-linux-amd64.tar.gz

# Extract and Install
tar -xf helm-linux-amd64.tar.gz
cd linux-amd64 && chmod 755 helm
mv helm /usr/bin/helm
```

### Rancher Manager

Complete the following commands on the first server node in the cluster.

#### Cert-Manager

```bash
# Sudo to Root
sudo su

# Set Variables
export DOMAIN=<example.com>
export vCertManager=1.18.2
export registry=<FQDN or IP>:5000
export fileserver=<FQDN or IP>:8080

# Create Namespace
kubectl create namespace cert-manager

# Install via Helm
helm upgrade -i cert-manager oci://${registry}/hauler/cert-manager:${vCertManager} -n cert-manager --set crds.enabled=true --set image.repository=$registry/jetstack/cert-manager-controller --set webhook.image.repository=$registry/jetstack/cert-manager-webhook --set cainjector.image.repository=$registry/jetstack/cert-manager-cainjector --set acmesolver.image.repository=$registry/jetstack/cert-manager-acmesolver --set startupapicheck.image.repository=$registry/jetstack/cert-manager-startupapicheck

# Configure Cert Manager
kubectl apply -f - << EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-issuer
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: tls-certs
  namespace: cert-manager
spec:
  issuerRef:
    name: selfsigned-issuer
    kind: ClusterIssuer
  secretName: tls-certs
  commonName: "$DOMAIN"
  dnsNames:
  - "$DOMAIN"
  - "*.$DOMAIN"
EOF
```

#### Rancher

```bash
# Sudo to Root
sudo su

# Set Variables
export DOMAIN=<example.com>
export vRancher=2.11.3
export registry=<FQDN or IP>:5000
export fileserver=<FQDN or IP>:8080

# Create Namespace
kubectl create namespace cattle-system

# Configure Cert Manager
kubectl apply -f - << EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: tls-certs
  namespace: cattle-system
spec:
  issuerRef:
    name: selfsigned-issuer
    kind: ClusterIssuer
  secretName: tls-certs
  commonName: "$DOMAIN"
  dnsNames:
  - "$DOMAIN"
  - "*.$DOMAIN"
EOF

# Install via Helm
helm upgrade -i rancher oci://${registry}/hauler/rancher:${vRancher} -n cattle-system --set bootstrapPassword=Pa22word --set ingress.tls.source=secret --set ingress.tls.secretName=tls-certs --set useBundledSystemChart=true --set systemDefaultRegistry=$registry --set rancherImage=$registry/rancher/rancher --set hostname=rancher.$DOMAIN

# Create Classification Banners
kubectl apply -f http://${fileserver}/rancher-banner-ufouo.yaml
```

### Longhorn

Complete the following commands on the first server node in the cluster.

```bash
# Sudo to Root
sudo su

# Set Variables
export DOMAIN=<example.com>
export vLonghorn=1.8.1
export registry=<FQDN or IP>:5000
export fileserver=<FQDN or IP>:8080

# Create Namespace
kubectl create namespace longhorn-system

# Install via Helm
helm upgrade -i longhorn oci://${registry}/hauler/longhorn:${vLonghorn} -n longhorn-system --version=$vLonghorn --set global.cattle.systemDefaultRegistry=$registry

# Create Encrypted Storage Class
kubectl apply -f http://${fileserver}/longhorn-encrypted-sc.yaml
```

### NeuVector

Complete the following commands on the first server node in the cluster.

```bash
# Sudo to Root
sudo su

# Set Variables
export DOMAIN=<example.com>
export vNeuVector=2.8.7
export registry=<FQDN or IP>:5000
export fileserver=<FQDN or IP>:8080

# Create Namespace
kubectl create namespace cattle-neuvector-system

# Install via Helm
helm upgrade -i neuvector oci://${registry}/hauler/core:${vNeuVector} -n cattle-neuvector-system --set k3s.enabled=true --set manager.svc.type=ClusterIP --set internal.certmanager.enabled=true --set controller.pvc.enabled=true --set controller.pvc.capacity=10Gi --set global.cattle.url=https://rancher.$DOMAIN --set controller.ranchersso.enabled=true --set rbac=true --set registry=$registry
```

### Gitea

Complete the following commands on the first server node in the cluster.

```bash
# Sudo to Root
sudo su

# Set Variables
export DOMAIN=<example.com>
export vGitea=10.3.0
export registry=<FQDN or IP>:5000
export fileserver=<FQDN or IP>:8080

# Create Namespace
kubectl create namespace gitea-system

# Configure Cert Manager
kubectl apply -f - << EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: tls-certs
  namespace: gitea-system
spec:
  issuerRef:
    name: selfsigned-issuer
    kind: ClusterIssuer
  secretName: tls-certs
  commonName: "$DOMAIN"
  dnsNames:
  - "$DOMAIN"
  - "*.$DOMAIN"
EOF

# Install via Helm
helm upgrade -i gitea oci://${registry}/hauler/gitea:${vGitea} -n gitea-system --set gitea.admin.username=gitea --set gitea.admin.password=Pa22word --set gitea.admin.email=gitea@$DOMAIN --set persistence.size=20Gi --set ingress.enabled=true --set ingress.hosts[0].host=gitea.$DOMAIN --set ingress.hosts[0].paths[0].path=/ --set ingress.hosts[0].paths[0].pathType=Prefix -set ingress.tls[0].secretName=tls-certs --set ingress.tls[0].hosts[0]=gitea.$DOMAIN --set gitea.config.server.DOMAIN=gitea.$DOMAIN --set global.imageRegistry=$registry
```
