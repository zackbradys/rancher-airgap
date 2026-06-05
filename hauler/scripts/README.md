# Rancher Airgap Component Version Bumper & Validator

This directory contains `bump_versions.py`, an automated script designed to verify, track, and update all SUSE cloud-native product component versions within the Rancher Airgap repository.

The script checks for newer releases of binaries and Helm charts, updates the shell scripts in `hauler/scripts/`, and automatically synchronizes the root `README.md` reference labels.

---

## Prerequisites

- **Python 3.x**: Installed on your workstation.
- **GitHub CLI (`gh`)**: Logged in and authenticated (`gh auth status`).
  * *Note: Using `gh api` completely circumvents unauthenticated anonymous rate limits and ensures reliable lookups.*

---

## Features

- **GitHub CLI Integration**: Uses local shell `gh` authentication to perform safe, high-speed API lookups.
- **Automatic Repo-Root Detection**: The script automatically detects the repository root directory, meaning it can be run from **any directory** (inside or outside the repository) without breaking file paths.
- **Stable Minor-Branch Matching (`minor_match`)**: For Kubernetes orchestration engines like **RKE2** and **K3s**, the script automatically restricts upgrades to the same minor branch (e.g. tracking latest patches in `1.34.x` instead of jumping to `1.35.x` or higher).
- **Helm Index Parsing**: Directly parses and parses indices (`index.yaml`) for Gitea, NeuVector, Kubewarden, and Vault Helm repositories to determine active, stable versions.
- **Auto-Syncs Documentation**: Bumps component reference version tags inside the root `README.md` automatically when updates are made.

---

## How to Use

### 1. Dry-Run Mode (Read-Only Comparison)
Compare currently defined versions in the local shell scripts with the latest upstream stable releases on GitHub and Helm repositories. **No files will be modified.**
```bash
python3 hauler/scripts/bump_versions.py
# OR
python3 hauler/scripts/bump_versions.py --dry-run
```

### 2. Bump Mode (Update Files Locally)
Write the latest matching versions directly to the variables in the corresponding shell scripts (located in `hauler/scripts/`) and update the labels in the root `README.md`.
```bash
python3 hauler/scripts/bump_versions.py --bump
```

### 3. Bump & Push Mode (Automated CI Integration)
Bumps all files locally, stages the modifications using git, commits the changes, and pushes them upstream to your configured Git remote origin.
```bash
python3 hauler/scripts/bump_versions.py --bump --push
```

---

## Hauler Manifest Validation & Compiler

This directory also contains `test_hauler.py`, a local test runner to compile and validate the generated manifests without needing root privileges or consuming immense bandwidth.

### Usage

**1. Fast Dry-Run Verification (Manifest compile + HTTP Head URL Pings)**:
```bash
python3 hauler/scripts/test_hauler.py
```

**2. Absolute Minimal Check (Compiles local manifests, skips URL pings)**:
```bash
python3 hauler/scripts/test_hauler.py --skip-ping
```

**3. Full Hauler Sync Check (Compiles, pings, and executes actual `hauler store sync` on a specific component to verify OCI serialization)**:
```bash
python3 hauler/scripts/test_hauler.py --sync --sync-only cosign,helm
```

---

## Monitored Variables & Files

The script tracks and manages the following variables across your manifests:

| Component | Target File | Variable Name | Upstream Source |
| :--- | :--- | :--- | :--- |
| **Hauler** | `hauler/scripts/hauler/hauler-hauler.sh` | `vHauler` | GitHub Release (`hauler-dev/hauler`) |
| **Helm** | `hauler/scripts/helm/hauler-helm.sh` | `vHelm` | GitHub Release (`helm/helm`) |
| **Cosign** | `hauler/scripts/cosign/hauler-cosign.sh` | `vCosign` | GitHub Release (`sigstore/cosign`) |
| **RKE2** | `hauler/scripts/rke2/hauler-rke2.sh` | `vRKE2` | GitHub Release (`rancher/rke2`) [Minor-Locked] |
| **K3S** | `hauler/scripts/k3s/hauler-k3s.sh` | `vK3S` | GitHub Release (`k3s-io/k3s`) [Minor-Locked] |
| **Rancher Manager** | `hauler/scripts/rancher/hauler-rancher.sh` | `vRancher` | GitHub Release (`rancher/rancher`) [Minor-Locked] |
| **Cert-Manager** | `hauler/scripts/rancher/hauler-rancher.sh` | `vCertManager` | GitHub Release (`cert-manager/cert-manager`) |
| **Longhorn** | `hauler/scripts/longhorn/hauler-longhorn.sh` | `vLonghorn` | GitHub Release (`longhorn/longhorn`) [Minor-Locked] |
| **NeuVector (Core)** | `hauler/scripts/neuvector/hauler-neuvector.sh` | `vNeuVector` | GitHub Release (`neuvector/neuvector`) |
| **NeuVector (Helm)**| `hauler/scripts/neuvector/hauler-neuvector.sh` | `vNeuVectorHelm`| Helm Repo Index (`https://neuvector.github.io/neuvector-helm`) |
| **Harvester** | `hauler/scripts/harvester/hauler-harvester.sh`| `vHarvester` | GitHub Release (`harvester/harvester`) [Minor-Locked] |
| **Kubewarden (Helm)**| `hauler/scripts/kubewarden/hauler-kubewarden.sh`| `vKubewarden` | Helm Repo Index (`https://charts.kubewarden.io`) |
| **Gitea (Helm)** | `hauler/scripts/gitea/hauler-gitea.sh` | `vGitea` | Helm Repo Index (`https://dl.gitea.com/charts`) |
| **Vault (Helm)** | `hauler/scripts/vault/hauler-vault.sh` | `vVault` | Helm Repo Index (`https://helm.releases.hashicorp.com`) |
