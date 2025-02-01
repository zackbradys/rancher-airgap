### Set Variables
export vKubewarden=4.1.0
export vKubewardenDefault=2.8.0

### Setup Working Directory
rm -rf /opt/hauler/kubewarden
mkdir -p /opt/hauler/kubewarden
cd /opt/hauler/kubewarden

### Download Kubewarden Images and Modify the List
### https://github.com/kubewarden/kubewarden-controller
helm repo add kubewarden https://charts.kubewarden.io && helm repo update
kubewardenControllerImages=$(helm template kubewarden/kubewarden-controller --version=${vKubewarden} | grep 'image:' | sed 's/"//g; s/.*image: //' | sed 's/^/    - name: /')
kubewardenDefaultImages=$(helm template kubewarden/kubewarden-defaults --version=${vKubewardenDefault} | grep 'image:' | sed 's/"//g; s/.*image: //' | sed 's/^/    - name: /')

### Create Hauler Manifest
cat << EOF >> /opt/hauler/kubewarden/rancher-airgap-kubewarden.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Charts
metadata:
  name: rancher-airgap-charts-kubewarden
spec:
  charts:
    - name: kubewarden-controller
      repoURL: https://charts.kubewarden.io
      version: ${vKubewarden}
    - name: kubewarden-defaults
      repoURL: https://charts.kubewarden.io
      version: ${vKubewardenDefault}
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Images
metadata:
  name: rancher-airgap-images-kubewarden
spec:
  images:
${kubewardenControllerImages}
${kubewardenDefaultImages}
EOF
