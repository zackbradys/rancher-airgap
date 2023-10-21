### Set Variables
export vHelm=3.13.1

### Setup Working Directory
rm -rf /opt/rancher/hauler/helm
mkdir -p /opt/rancher/hauler/helm
cd /opt/rancher/hauler/helm

### Install Helm
### https://github.com/helm/helm/
curl -#OL https://get.helm.sh/helm-v${vHelm}-linux-amd64.tar.gz
tar -xf helm-v${vHelm}-linux-amd64.tar.gz && mv linux-amd64/* . && rm -rf linux-amd64

### Compress Helm
tar -czvf /opt/rancher/hauler/rancher-airgap-helm.tar.zst .