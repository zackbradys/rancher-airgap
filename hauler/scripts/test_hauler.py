#!/usr/bin/env python3
import os
import sys
import re
import urllib.request
import subprocess
import argparse
import shutil

def get_repo_root():
    try:
        res = subprocess.run(["git", "rev-parse", "--show-toplevel"], capture_output=True, text=True, check=True)
        return res.stdout.strip()
    except Exception:
        curr = os.path.abspath(os.getcwd())
        while curr != os.path.dirname(curr):
            if os.path.exists(os.path.join(curr, ".git")):
                return curr
            curr = os.path.dirname(curr)
        return os.getcwd()

def run_cmd(cmd, cwd=None):
    try:
        res = subprocess.run(cmd, capture_output=True, text=True, shell=True, cwd=cwd)
        return res.returncode, res.stdout, res.stderr
    except Exception as e:
        return -1, "", str(e)

def generate_local_manifests(repo_root, build_dir):
    """
    Generates manifests locally by rewriting /opt/hauler inside shell scripts to a local build directory
    to prevent permission issues (no sudo or write access to /opt required).
    """
    print("\n[+] Step 1: Generating Manifests Locally...")
    scripts_dir = os.path.join(repo_root, "hauler/scripts")
    manifests_out = os.path.join(build_dir, "manifests")
    os.makedirs(manifests_out, exist_ok=True)

    # Temporary execution directory
    tmp_exec_dir = os.path.join(build_dir, "tmp_exec")
    os.makedirs(tmp_exec_dir, exist_ok=True)

    # Find all .sh scripts recursively
    sh_files = []
    for root, _, files in os.walk(scripts_dir):
        for f in files:
            if f.endswith(".sh"):
                sh_files.append(os.path.join(root, f))

    for sh_file in sh_files:
        rel_path = os.path.relpath(sh_file, scripts_dir)
        component = os.path.dirname(rel_path)
        script_name = os.path.basename(sh_file)

        print(f"  -> Processing generator: {rel_path}")

        try:
            with open(sh_file, "r") as f:
                content = f.read()

            # Rewrite /opt/hauler paths to build_dir
            rewritten_content = content.replace("/opt/hauler", os.path.join(build_dir, "opt"))

            # Save to tmp execution folder
            exec_subdir = os.path.join(tmp_exec_dir, component)
            os.makedirs(exec_subdir, exist_ok=True)
            tmp_sh_file = os.path.join(exec_subdir, script_name)

            with open(tmp_sh_file, "w") as f:
                f.write(rewritten_content)

            # Make executable
            os.chmod(tmp_sh_file, 0o755)

            # Run the generator script
            code, stdout, stderr = run_cmd(f"./{script_name}", cwd=exec_subdir)
            if code != 0:
                print(f"    [Error] Generator failed: {stderr.strip()}")
                continue

            # Locate the generated yaml files and copy them to manifests_out
            opt_component_dir = os.path.join(build_dir, f"opt/{component}")
            if os.path.exists(opt_component_dir):
                for f_name in os.listdir(opt_component_dir):
                    if f_name.endswith(".yaml"):
                        shutil.copy2(
                            os.path.join(opt_component_dir, f_name),
                            os.path.join(manifests_out, f_name)
                        )
                        print(f"    [✓] Generated: {f_name}")

        except Exception as e:
            print(f"    [Error] Processing {script_name} failed: {e}")

    # Clean up tmp exec
    shutil.rmtree(tmp_exec_dir, ignore_errors=True)
    print(f"[✓] Local manifests successfully compiled in: {manifests_out}")

def validate_manifest_urls(build_dir):
    """
    Pings (via HEAD requests) all URL paths inside Files manifests to ensure they are 100% active,
    resolving the #1 cause of airgap build failures without downloading gigabytes of data.
    """
    print("\n[+] Step 2: Validating Download URLs in Manifests...")
    manifests_dir = os.path.join(build_dir, "manifests")
    if not os.path.exists(manifests_dir):
        print("  [Error] No generated manifests found. Run generation first.")
        return

    yaml_files = [os.path.join(manifests_dir, f) for f in os.listdir(manifests_dir) if f.endswith(".yaml")]

    url_pattern = re.compile(r"path:\s*['\"]?(https?://[^\s'\"]+)['\"]?")
    
    total_checked = 0
    total_failed = 0

    for yaml_file in yaml_files:
        print(f"  -> Scanning {os.path.basename(yaml_file)}")
        try:
            with open(yaml_file, "r") as f:
                content = f.read()

            urls = url_pattern.findall(content)
            if not urls:
                continue

            for url in set(urls):
                total_checked += 1
                try:
                    # Execute a HEAD request to check availability
                    req = urllib.request.Request(url, method="HEAD", headers={"User-Agent": "hauler-tester"})
                    with urllib.request.urlopen(req, timeout=10) as resp:
                        status = resp.status
                        if status in [200, 301, 302]:
                            print(f"    [✓] REACHABLE (HTTP {status}): {url}")
                        else:
                            print(f"    [!] UNEXPECTED STATUS (HTTP {status}): {url}")
                            total_failed += 1
                except Exception as e:
                    print(f"    [X] UNREACHABLE: {url} | Error: {e}")
                    total_failed += 1

        except Exception as e:
            print(f"    [Error] Reading {yaml_file}: {e}")

    print(f"\n[✓] URL Verification Complete! Checked: {total_checked} | Failed: {total_failed}")
    if total_failed > 0:
        print("  [Warning] Some download links are broken or unreachable!")

def run_hauler_sync(build_dir, components_to_sync):
    """
    Executes actual hauler store sync on the generated manifests to verify that the
    hauler parser processes them cleanly.
    """
    print("\n[+] Step 3: Executing Hauler Store Sync Test...")
    manifests_dir = os.path.join(build_dir, "manifests")
    store_dir = os.path.join(build_dir, "store")
    
    if not os.path.exists(manifests_dir):
        print("  [Error] No generated manifests found. Run generation first.")
        return

    # Check if hauler is available
    if shutil.which("hauler") is None:
        print("  [Error] 'hauler' binary is not installed on this system. Skipping sync test.")
        return

    yaml_files = os.listdir(manifests_dir)
    if components_to_sync:
        # Filter files matching input filter
        yaml_files = [f for f in yaml_files if any(c in f for c in components_to_sync)]

    if not yaml_files:
        print("  [-] No matching manifests to sync.")
        return

    for yaml_file in yaml_files:
        yaml_path = os.path.join(manifests_dir, yaml_file)
        print(f"  -> Testing sync for {yaml_file}...")
        
        # We run the sync command
        cmd = f"hauler store sync --filename {yaml_path} --store {store_dir}"
        print(f"     Running: {cmd}")
        
        code, stdout, stderr = run_cmd(cmd)
        if code == 0:
            print(f"    [✓] Sync Succeeded!")
        else:
            print(f"    [X] Sync Failed! Error: {stderr.strip()}")

def main():
    parser = argparse.ArgumentParser(description="Test and Validate generated Hauler manifests.")
    parser.add_argument("--sync", action="store_true", help="Run actual 'hauler store sync' test (caution: downloads files)")
    parser.add_argument("--sync-only", type=str, help="Comma-separated list of components to sync (e.g. cosign,helm)")
    parser.add_argument("--skip-ping", action="store_true", help="Skip URL verification pings")
    args = parser.parse_args()

    repo_root = get_repo_root()
    build_dir = os.path.join(repo_root, "build")

    print("====================================================")
    print("         RANCHER AIRGAP HAULER MANIFEST TESTER       ")
    print("====================================================")
    print(f"Repo Root: {repo_root}")
    print(f"Build Dir: {build_dir}")

    # Step 1: Compile the manifests locally
    generate_local_manifests(repo_root, build_dir)

    # Step 2: Run URL head verification pings
    if not args.skip_ping:
        validate_manifest_urls(build_dir)

    # Step 3: Optional Hauler sync validation
    if args.sync or args.sync_only:
        components = []
        if args.sync_only:
            components = [c.strip() for c in args.sync_only.split(",")]
        run_hauler_sync(build_dir, components)

    print("\n====================================================")
    print("Validation run complete. Check output details above.")
    print("====================================================")

if __name__ == "__main__":
    main()
