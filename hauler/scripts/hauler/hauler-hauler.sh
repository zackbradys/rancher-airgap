### Set Variables
export vHauler=0.4.0

### Setup Working Directory
rm -rf /opt/rancher/hauler/hauler
mkdir -p /opt/rancher/hauler/hauler
cd /opt/rancher/hauler/hauler

### Download Hauler
### https://github.com/rancherfederal/hauler
curl -#OL https://github.com/rancherfederal/hauler/releases/download/v${vHauler}/hauler_${vHauler}_linux_amd64.tar.gz
tar -xf hauler_${vHauler}_linux_amd64.tar.gz

### Compress Hauler
tar -czvf /opt/rancher/hauler/rancher-airgap-hauler.tar.zst .