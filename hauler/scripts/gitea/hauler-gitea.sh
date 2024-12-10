### Set Variables
export vGitea=10.6.0

### Setup Working Directory
rm -rf /opt/hauler/gitea
mkdir -p /opt/hauler/gitea
cd /opt/hauler/gitea

### Download Gitea Images and Modify the List
### https://github.com/go-gitea/gitea
helm repo add gitea-charts https://dl.gitea.com/charts && helm repo update
giteaImages=$(helm template gitea-charts/gitea --version=${vGitea} | grep 'image:' | sed 's/"//g; s/.*image: //' | sed 's/^/    - name: /')

### Create Hauler Manifest
cat << EOF >> /opt/hauler/gitea/rancher-airgap-gitea.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Charts
metadata:
  name: rancher-airgap-charts-gitea
spec:
  charts:
    - name: gitea
      repoURL: https://dl.gitea.com/charts
      version: ${vGitea}
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Images
metadata:
  name: rancher-airgap-images-gitea
spec:
  images:
${giteaImages}
EOF
