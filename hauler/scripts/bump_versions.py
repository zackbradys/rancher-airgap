#!/usr/bin/env python3
import os
import sys
import re
import urllib.request
import json
import argparse
import subprocess

# Configuration of all components to track and update
CONFIGS = [
    {
        "name": "Hauler (Binary)",
        "file": "hauler/scripts/hauler/hauler-hauler.sh",
        "var": "vHauler",
        "source": {"type": "github", "repo": "hauler-dev/hauler", "strip_v": True},
        "minor_match": False,
        "readme_pattern": r"Hauler: v(\d+\.\d+\.\d+)",
        "readme_replace": "Hauler: v{}"
    },
    {
        "name": "Helm (Binary)",
        "file": "hauler/scripts/helm/hauler-helm.sh",
        "var": "vHelm",
        "source": {"type": "github", "repo": "helm/helm", "strip_v": True},
        "minor_match": False,
        "readme_pattern": r"Helm: v(\d+\.\d+\.\d+)",
        "readme_replace": "Helm: v{}"
    },
    {
        "name": "Cosign",
        "file": "hauler/scripts/cosign/hauler-cosign.sh",
        "var": "vCosign",
        "source": {"type": "github", "repo": "sigstore/cosign", "strip_v": True},
        "minor_match": False,
        "readme_pattern": r"Cosign: v(\d+\.\d+\.\d+)",
        "readme_replace": "Cosign: v{}"
    },
    {
        "name": "RKE2",
        "file": "hauler/scripts/rke2/hauler-rke2.sh",
        "var": "vRKE2",
        "source": {"type": "github", "repo": "rancher/rke2", "strip_v": True},
        "minor_match": True,  # Keep same minor branch (e.g. 1.34)
        "readme_pattern": r"RKE2: v(\d+\.\d+\.\d+)",
        "readme_replace": "RKE2: v{}"
    },
    {
        "name": "K3S",
        "file": "hauler/scripts/k3s/hauler-k3s.sh",
        "var": "vK3S",
        "source": {"type": "github", "repo": "k3s-io/k3s", "strip_v": True},
        "minor_match": True,  # Keep same minor branch (e.g. 1.34)
        "readme_pattern": r"K3S: v(\d+\.\d+\.\d+)",
        "readme_replace": "K3S: v{}"
    },
    {
        "name": "Rancher Manager",
        "file": "hauler/scripts/rancher/hauler-rancher.sh",
        "var": "vRancher",
        "source": {"type": "github", "repo": "rancher/rancher", "strip_v": True},
        "minor_match": True,  # Keep same minor branch (e.g. 2.13)
        "readme_pattern": r"Rancher: v(\d+\.\d+\.\d+)",
        "readme_replace": "Rancher: v{}"
    },
    {
        "name": "Rancher Manager (Minimal)",
        "file": "hauler/scripts/rancher/hauler-rancher-minimal.sh",
        "var": "vRancher",
        "source": {"type": "github", "repo": "rancher/rancher", "strip_v": True},
        "minor_match": True,
    },
    {
        "name": "Cert-Manager",
        "file": "hauler/scripts/rancher/hauler-rancher.sh",
        "var": "vCertManager",
        "source": {"type": "github", "repo": "cert-manager/cert-manager", "strip_v": True},
        "minor_match": False,
        "readme_pattern": r"Cert-Manager: v(\d+\.\d+\.\d+)",
        "readme_replace": "Cert-Manager: v{}"
    },
    {
        "name": "Cert-Manager (Minimal)",
        "file": "hauler/scripts/rancher/hauler-rancher-minimal.sh",
        "var": "vCertManager",
        "source": {"type": "github", "repo": "cert-manager/cert-manager", "strip_v": True},
        "minor_match": False,
    },
    {
        "name": "Longhorn",
        "file": "hauler/scripts/longhorn/hauler-longhorn.sh",
        "var": "vLonghorn",
        "source": {"type": "github", "repo": "longhorn/longhorn", "strip_v": True},
        "minor_match": True,
        "readme_pattern": r"Longhorn: v(\d+\.\d+\.\d+)",
        "readme_replace": "Longhorn: v{}"
    },
    {
        "name": "NeuVector (Core)",
        "file": "hauler/scripts/neuvector/hauler-neuvector.sh",
        "var": "vNeuVector",
        "source": {"type": "github", "repo": "neuvector/neuvector", "strip_v": True},
        "minor_match": False,
        "readme_pattern": r"NeuVector: v(\d+\.\d+\.\d+)",
        "readme_replace": "NeuVector: v{}"
    },
    {
        "name": "NeuVector (Helm)",
        "file": "hauler/scripts/neuvector/hauler-neuvector.sh",
        "var": "vNeuVectorHelm",
        "source": {"type": "helm", "repo_url": "https://neuvector.github.io/neuvector-helm", "chart": "core"},
        "minor_match": False,
    },
    {
        "name": "Harvester",
        "file": "hauler/scripts/harvester/hauler-harvester.sh",
        "var": "vHarvester",
        "source": {"type": "github", "repo": "harvester/harvester", "strip_v": True},
        "minor_match": True,
        "readme_pattern": r"Harvester: v(\d+\.\d+\.\d+)",
        "readme_replace": "Harvester: v{}"
    },
    {
        "name": "Kubewarden Controller (Helm)",
        "file": "hauler/scripts/kubewarden/hauler-kubewarden.sh",
        "var": "vKubewarden",
        "source": {"type": "helm", "repo_url": "https://charts.kubewarden.io", "chart": "kubewarden-controller"},
        "minor_match": False,
        "readme_pattern": r"KubeWarden: v(\d+\.\d+\.\d+)",
        "readme_replace": "KubeWarden: v{}"
    },
    {
        "name": "Kubewarden Defaults (Helm)",
        "file": "hauler/scripts/kubewarden/hauler-kubewarden.sh",
        "var": "vKubewardenDefault",
        "source": {"type": "helm", "repo_url": "https://charts.kubewarden.io", "chart": "kubewarden-defaults"},
        "minor_match": False,
    },
    {
        "name": "Gitea (Helm)",
        "file": "hauler/scripts/gitea/hauler-gitea.sh",
        "var": "vGitea",
        "source": {"type": "helm", "repo_url": "https://dl.gitea.com/charts", "chart": "gitea"},
        "minor_match": False,
        "readme_pattern": r"Gitea: v(\d+\.\d+\.\d+)",
        "readme_replace": "Gitea: v{}"
    },
    {
        "name": "Vault (Helm)",
        "file": "hauler/scripts/vault/hauler-vault.sh",
        "var": "vVault",
        "source": {"type": "helm", "repo_url": "https://helm.releases.hashicorp.com", "chart": "vault"},
        "minor_match": False,
        "readme_pattern": r"Vault: v(\d+\.\d+\.\d+)",
        "readme_replace": "Vault: v{}"
    },
]

def run_cmd(cmd_args):
    try:
        res = subprocess.run(cmd_args, capture_output=True, text=True, check=True)
        return res.stdout.strip()
    except Exception as e:
        return None

def get_repo_root():
    # Find root by running git rev-parse --show-toplevel
    try:
        res = subprocess.run(["git", "rev-parse", "--show-toplevel"], capture_output=True, text=True, check=True)
        return res.stdout.strip()
    except Exception:
        # Fallback to searching upwards for .git or using current dir
        curr = os.path.abspath(os.getcwd())
        while curr != os.path.dirname(curr):
            if os.path.exists(os.path.join(curr, ".git")):
                return curr
            curr = os.path.dirname(curr)
        return os.getcwd()

def get_latest_github_release(repo, current_version=None, minor_match=False, strip_v=True):
    # Query GitHub API utilizing the locally authenticated 'gh' CLI tool
    cmd = [
        "gh", "api", f"repos/{repo}/releases", 
        "--jq", "map(select(.prerelease == false and .draft == false)) | .[].tag_name"
    ]
    stdout = run_cmd(cmd)
    
    if not stdout:
        # Fallback to tags
        cmd = ["gh", "api", f"repos/{repo}/tags", "--jq", ".[].name"]
        stdout = run_cmd(cmd)
        
    if not stdout:
        return None
        
    stable_releases = [line.strip() for line in stdout.splitlines() if line.strip()]
            
    if minor_match and current_version:
        parts = current_version.split(".")
        if len(parts) >= 2:
            prefix = f"{parts[0]}.{parts[1]}"
            for tag in stable_releases:
                cleaned_tag = tag.lstrip("v")
                if cleaned_tag.startswith(prefix):
                    if "+" in cleaned_tag:
                        cleaned_tag = cleaned_tag.split("+")[0]
                    return cleaned_tag if strip_v else tag
                    
    if stable_releases:
        latest_tag = stable_releases[0]
        cleaned_tag = latest_tag.lstrip("v")
        if "+" in cleaned_tag:
            cleaned_tag = cleaned_tag.split("+")[0]
        return cleaned_tag if strip_v else latest_tag
        
    return None

def get_latest_helm_chart_version(repo_url, chart_name):
    url = f"{repo_url.rstrip('/')}/index.yaml"
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "hauler-version-updater"})
        with urllib.request.urlopen(req) as response:
            index_content = response.read().decode('utf-8')
    except Exception as e:
        print(f"  [Error] Helm index failed for {repo_url}: {e}")
        return None
        
    lines = index_content.splitlines()
    in_entries = False
    in_chart = False
    
    for line in lines:
        stripped = line.strip()
        if not stripped:
            continue
        indent = len(line) - len(line.lstrip())
        
        if stripped == "entries:":
            in_entries = True
            continue
            
        if in_entries:
            if indent == 0:
                in_entries = False
                in_chart = False
                continue
            
            # Check if we are at chart definition level (usually 2 spaces)
            if indent == 2 and not stripped.startswith("- "):
                if stripped.startswith(chart_name + ":"):
                    in_chart = True
                else:
                    in_chart = False
                continue
                
            if in_chart:
                if stripped.startswith("version:"):
                    return stripped.split(":", 1)[1].strip().strip('"').strip("'")
                if stripped.startswith("- version:"):
                    return stripped.split(":", 1)[1].strip().strip('"').strip("'")
                if indent > 2 and stripped.startswith("version:"):
                    return stripped.split(":", 1)[1].strip().strip('"').strip("'")
                    
    return None

def get_current_version_from_file(file_path, var_name):
    if not os.path.exists(file_path):
        print(f"  [Error] File not found: {file_path}")
        return None
    try:
        with open(file_path, "r") as f:
            content = f.read()
    except Exception as e:
        print(f"  [Error] Reading file {file_path}: {e}")
        return None
        
    pattern = rf"export\s+{var_name}\s*=\s*['\"]?([0-9a-zA-Z\.\-\+]+)['\"]?"
    match = re.search(pattern, content)
    if match:
        return match.group(1)
    return None

def update_version_in_file(file_path, var_name, new_version):
    if not os.path.exists(file_path):
        return False
    try:
        with open(file_path, "r") as f:
            content = f.read()
    except Exception as e:
        print(f"  [Error] Reading file {file_path}: {e}")
        return False
        
    pattern = rf"(export\s+{var_name}\s*=\s*['\"]?)([0-9a-zA-Z\.\-\+]+)(['\"]?)"
    new_content, count = re.subn(pattern, r"\g<1>" + new_version + r"\g<3>", content)
    if count > 0:
        try:
            with open(file_path, "w") as f:
                f.write(new_content)
            return True
        except Exception as e:
            print(f"  [Error] Writing to file {file_path}: {e}")
            return False
    return False

def update_readme_version(readme_path, pattern, replacement_val):
    if not os.path.exists(readme_path):
        return False
    try:
        with open(readme_path, "r") as f:
            content = f.read()
    except Exception as e:
        print(f"  [Error] Reading {readme_path}: {e}")
        return False
        
    new_content, count = re.subn(pattern, replacement_val, content)
    if count > 0:
        try:
            with open(readme_path, "w") as f:
                f.write(new_content)
            return True
        except Exception as e:
            print(f"  [Error] Writing to {readme_path}: {e}")
            return False
    return False

def main():
    parser = argparse.ArgumentParser(description="Verify and update Rancher Airgap SUSE product component versions.")
    parser.add_argument("--bump", action="store_true", help="Bump variables in script files to matched latest versions")
    parser.add_argument("--push", action="store_true", help="Automatically commit and push script updates to Git")
    parser.add_argument("--dry-run", action="store_true", help="Run the version checker in dry-run mode (default behavior)")
    args = parser.parse_args()

    repo_root = get_repo_root()
    readme_path = os.path.join(repo_root, "README.md")

    is_dry_run = args.dry_run or (not args.bump and not args.push)

    print("====================================================")
    print("      RANCHER AIRGAP VERSION VALIDATOR & BUMPER     ")
    print(f"      Mode: {'DRY-RUN (Read-Only)' if is_dry_run else 'BUMP & UPDATE'}")
    print("====================================================")

    updates_made = []
    has_changes = False

    for config in CONFIGS:
        name = config["name"]
        file_rel_path = config["file"]
        file_path = os.path.join(repo_root, file_rel_path)
        var_name = config["var"]
        source = config["source"]
        minor_match = config["minor_match"]

        current = get_current_version_from_file(file_path, var_name)
        if not current:
            print(f"[-] {name:<30} | Skipping (could not parse current version)")
            continue

        latest = None
        if source["type"] == "github":
            latest = get_latest_github_release(
                source["repo"], 
                current_version=current, 
                minor_match=minor_match, 
                strip_v=source["strip_v"]
            )
        elif source["type"] == "helm":
            latest = get_latest_helm_chart_version(source["repo_url"], source["chart"])

        if not latest:
            print(f"[-] {name:<30} | Current: {current:<10} | Failed to fetch latest")
            continue

        if current != latest:
            print(f"[!] {name:<30} | Current: {current:<10} | LATEST: {latest:<10} (BUMP DETECTED!)")
            has_changes = True
            
            if not is_dry_run and args.bump:
                if update_version_in_file(file_path, var_name, latest):
                    print(f"    -> Updated variable {var_name} to {latest} in {file_rel_path}")
                    updates_made.append((name, current, latest, file_rel_path))
                    
                    # Try to update README.md if patterns exist
                    if "readme_pattern" in config and "readme_replace" in config:
                        pattern = config["readme_pattern"]
                        replacement = config["readme_replace"].format(latest)
                        if update_readme_version(readme_path, pattern, replacement):
                            print(f"    -> Updated component tag in README.md")
                else:
                    print(f"    -> [Error] Failed to update {var_name} in {file_rel_path}")
        else:
            print(f"[✓] {name:<30} | Current: {current:<10} | Up to date")

    print("\n====================================================")
    if has_changes and is_dry_run:
        print("[!] Out of date components detected! Run with '--bump' to automatically update scripts.")
    elif updates_made:
        print(f"[✓] Successfully bumped {len(updates_made)} component variables!")
        
        if args.push:
            print("\nStaging changes and pushing to upstream Git repository...")
            os.system(f"git add {os.path.join(repo_root, 'hauler/scripts')}/**/*.sh {readme_path}")
            commit_msg = "chore: bump rancher-airgap component versions to latest"
            exit_code = os.system(f'git commit -m "{commit_msg}"')
            if exit_code == 0:
                os.system("git push")
                print("[✓] Pushed version bumps upstream successfully!")
            else:
                print("[-] No changes committed (nothing modified or commit failed)")
    else:
        print("[✓] Everything is already up to date!")
    print("====================================================")

if __name__ == "__main__":
    main()
