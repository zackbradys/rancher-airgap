### Set Variables
export vHauler=0.3.0
export vRKE2=1.24.15
export vRancher=2.7.5
export vLonghorn=1.5.0
export vNeuVector=2.6.0
export vCertManager=1.7.1
export vHarbor=1.7.5
export vKubeWardenDefaults=1.6.1
export vKubeWardenController=1.5.3

### Install Hauler
mkdir -p /opt/rancher/hauler
cd /opt/rancher/hauler
curl -#OL https://github.com/rancherfederal/hauler/releases/download/v${vHauler}/hauler_${vHauler}_linux_amd64.tar.gz
cp hauler /usr/bin/hauler

### Create Rancher Offline YUM Repo
mkdir -p /opt/rancher/hauler/rancher-offline-packages
cd /opt/rancher/hauler/rancher-offline-packages
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

repotrack -y zip zstd skopeo createrepo tree terraform iptables container-selinux libnetfilter_conntrack libnfnetlink libnftnl policycoreutils-python-utils cryptsetup iscsi-initiator-utils docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
tar -I zstd -vcf /opt/rancher/hauler/rancher-offline-packages.tar.zst $(ls)
cd /opt/rancher/hauler && rm -rf rancher-offline-packages

### Download Images
mkdir -p /opt/rancher/hauler/rancher-offline-images
cd /opt/rancher/hauler/rancher-offline-images
curl -#L https://github.com/rancher/rke2/releases/download/v${vRKE2}+rke2r1/rke2-images-all.linux-amd64.txt -o rke2-images.txt
sed -i "s#docker.io/#    - name: #g" rke2-images.txt

curl -#L https://github.com/rancher/rancher/releases/download/v${vRancher}/rancher-images.txt -o rancher-images.txt
sed -i "s#^#    - name: #" rancher-images.txt

curl -#L https://raw.githubusercontent.com/longhorn/longhorn/v${vLonghorn}/deploy/longhorn-images.txt -o longhorn-images.txt
sed -i "s#^#    - name: #" longhorn-images.txt

### Add Image Helm Chart Repos
helm repo add jetstack https://charts.jetstack.io
helm repo add neuvector https://neuvector.github.io/neuvector-helm
helm repo add rancher-charts https://charts.rancher.io
helm repo add goharbor https://helm.goharbor.io
helm repo update

helm template jetstack/cert-manager --version=${vCertManager} | grep 'image:' | sed 's/"//g' | awk '{ print $2 }' > cert-manager-images.txt
sed -i "s#quay.io/#    - name: #g" cert-manager-images.txt

helm template neuvector/core --version=${vNeuVector} | grep 'image:' | sed 's/"//g' | awk '{ print $2 }' > neuvector-images.txt
sed -i "s#docker.io/#    - name: #g" neuvector-images.txt


helm template goharbor/harbor --version=${vHarbor} | grep 'image:' | sed 's/"//g' | sed "s/'//g" | awk '{ print $2 }' > harbor-images.txt
sed -i "s#^#    - name: #" harbor-images.txt

cat rke2-images.txt rancher-images.txt longhorn-images.txt cert-manager-images.txt neuvector-images.txt harbor-images.txt > rancher-offline-images.txt

### Load Store Contents
hauler store sync -f rancher-offline.yaml --store rancher-offline

### Verify Store Contents
hauler store info --store rancher-offline

### Save Store Contents
hauler store save --filename rancher-offline.tar.zst