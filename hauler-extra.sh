### Add Helm Charts (rancher-offline)
hauler store add chart cert-manager --repo "https://charts.jetstack.io" --version=1.7.1 --store rancher-offline
hauler store add chart rancher --repo "https://releases.rancher.com/server-charts/latest" --version=2.7.5 --store rancher-offline
hauler store add chart longhorn --repo "https://charts.longhorn.io" --version=1.5.0 --store rancher-offline
hauler store add chart core --repo "https://neuvector.github.io/neuvector-helm" --version=2.6.0 --store rancher-offline
hauler store add chart ui-plugin-operator --repo "https://charts.rancher.io" --version=102.0.0+up0.2.0 --store rancher-offline
hauler store add chart ui-plugin-operator-crd --repo "https://charts.rancher.io" --version=102.0.0+up0.2.0 --store rancher-offline
hauler store add chart rancher-monitoring-crd --repo "https://charts.rancher.io" --version=102.0.1+up40.1.2 --store rancher-offline
hauler store add chart rancher-monitoring --repo "https://charts.rancher.io" --version=102.0.1+up40.1.2 --store rancher-offline
hauler store add chart kubewarden-crds --repo "https://charts.kubewarden.io" --version=1.3.1 --store rancher-offline
hauler store add chart kubewarden-controller --repo "https://charts.kubewarden.io" --version=1.5.3 --store rancher-offline
hauler store add chart kubewarden-defaults --repo "https://charts.kubewarden.io" --version=1.6.1 --store rancher-offline

### Add Required Packages
hauler store add file "https://github.com/rancherfederal/hauler/releases/download/v0.3.0/hauler_0.3.0_linux_amd64.tar.gz" --name hauler --store rancher-offline
hauler store add file "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" --name awscli --store rancher-offline
hauler store add file "https://github.com/sigstore/cosign/releases/download/v1.8.0/cosign-linux-amd64" --name cosign --store rancher-offline
hauler store add file "https://get.helm.sh/helm-v3.11.1-linux-386.tar.gz" --name helm --store rancher-offline
hauler store add file "https://releases.hashicorp.com/terraform-provider-aws/4.54.0/terraform-provider-aws_4.54.0_linux_386.zip" --name terraform-provider-aws-linux386 --store rancher-offline
hauler store add file "https://releases.hashicorp.com/terraform-provider-aws/4.54.0/terraform-provider-aws_4.54.0_linux_amd64.zip" --name terraform-provider-aws-amd64 --store rancher-offline
hauler store add file "/opt/rancher/hauler/rancher-offline-packages.tar.zst" --name rancher-offline-packages --store rancher-offline

### Add Required Files
hauler store add file "https://github.com/rancher/rke2/releases/download/v1.24.15%2Brke2r1/rke2-images.linux-amd64.tar.zst" --name rke2-images --store rancher-offline
hauler store add file "https://github.com/rancher/rke2/releases/download/v1.24.15%2Brke2r1/rke2.linux-amd64.tar.gz" --name rke2-linux --store rancher-offline
hauler store add file "https://github.com/rancher/rke2/releases/download/v1.24.15%2Brke2r1/sha256sum-amd64.txt" --name rke2-sha256sum --store rancher-offline
hauler store add file "https://github.com/rancher/rke2-packaging/releases/download/v1.24.15%2Brke2r1.stable.0/rke2-common-1.24.10.rke2r1-0.x86_64.rpm" --name rke2-common --store rancher-offline
hauler store add file "https://github.com/rancher/rke2-selinux/releases/download/v0.14.stable.1/rke2-selinux-0.14-1.el9.noarch.rpm" --name rke2-selinux --store rancher-offline
hauler store add file "https://github.com/rancher/rke2/blob/master/install.sh" --name install.sh --store rancher-offline

hauler store add file "https://github.com/zackbradys/code-templates/blob/main/k8s/yamls/rancher-banner-ufouo.yaml" --name rancher-banner-ufouo --store rancher-offline
hauler store add file "https://github.com/zackbradys/code-templates/blob/main/k8s/yamls/rancher-banner-tssci.yaml" --name rancher-banner-tssci --store rancher-offline
hauler store add file "https://github.com/zackbradys/code-templates/blob/main/k8s/yamls/longhorn-volume.yaml" --name longhorn=volume --store rancher-offline
hauler store add file "https://github.com/zackbradys/code-templates/blob/main/k8s/yamls/longhorn-volume-test.yaml" --name longhorn-volume-test --store rancher-offline

helm template kubewarden/kubewarden-defaults --version=${vKubeWardenDefaults} | grep 'image:' | sed 's/"//g' | sed "s/'//g" | awk '{ print $2 }' > kubewarden-defaults-images.txt
sed -i "s#ghcr.io/#    - name: #g" kubewarden-defaults-images.txt

helm template kubewarden/kubewarden-controller --version=${vKubeWardenController} | grep 'image:' | sed 's/"//g' | sed "s/'//g" | awk '{ print $2 }' > kubewarden-controller-images.txt
sed -i "s#ghcr.io/#    - name: #g" kubewarden-controller-images.txt