# Set Variables
export vKubewarden=5.2.0
export vKubewardenDefault=3.2.0
export vKubewardenCRDs=1.16.0

# Setup Working Directory
rm -rf /opt/hauler/kubewarden
mkdir -p /opt/hauler/kubewarden
cd /opt/hauler/kubewarden

# Download Kubewarden Images and Modify the List
# https://github.com/kubewarden/kubewarden-controller
helm repo add kubewarden https://charts.kubewarden.io && helm repo update
kubewardenControllerImages=$(helm template kubewarden/kubewarden-controller --version=${vKubewarden} | grep 'image:' | sed 's/["'\'']//g; s/.*image: /    - name: /')
kubewardenDefaultImages=$(helm template kubewarden/kubewarden-defaults --version=${vKubewardenDefault} | grep 'image:' | sed 's/"//g; s/.*image: //' | sed 's/^/    - name: /')

# Create Hauler Manifest
cat << EOF >> /opt/hauler/kubewarden/rancher-airgap-kubewarden.yaml
apiVersion: content.hauler.cattle.io/v1
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
    - name: kubewarden-crds
      repoURL: https://charts.kubewarden.io
      version: ${vKubewardenCRDs}
---
apiVersion: content.hauler.cattle.io/v1
kind: Images
metadata:
  name: rancher-airgap-images-kubewarden
spec:
  images:
${kubewardenControllerImages}
${kubewardenDefaultImages}
EOF
