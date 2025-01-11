# Homelab with K3s

Using Arch Linux minimal + k3s
Flux for gitops

## Hosted apps

| Name               | Type                      |
|--------------------|---------------------------|
| Linkding           | Bookmark Manager          |
| Grafana            | Dashboard                 |

## To do

| Name               | Type                      |
|--------------------|---------------------------|
| Mealie             | Recipe Manager            |
| Vikunja            | Kanban+Project Management |
| Postgres           | Database                  |
| 


# Base Install
- Bare metal install Ubuntu server, only install SSH, reboot
- Copy ssh-key to host for passwordless auth (``ssh-copy-id user@host``)
- Install base utils ``sudo apt update -y ; sudo apt upgrade -y ; suto apd install vim git curl htop``
- Install K3s w/o helm ``curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=helm-controller" sh``
- Reboot host 

## Confirm operational

```bash
bl@k3s-master:~$ sudo kubectl get ns
NAME              STATUS   AGE
default           Active   118s
kube-node-lease   Active   118s
kube-public       Active   118s
kube-system       Active   118s
```

```bash
bl@k3s-master:~$ sudo kubectl get pods -A
NAMESPACE     NAME                                      READY   STATUS      RESTARTS   AGE
kube-system   coredns-ccb96694c-t662d                   1/1     Running     0          2m14s
kube-system   helm-install-traefik-crd-rhvjj            0/1     Completed   0          2m15s
kube-system   helm-install-traefik-rhmhh                0/1     Completed   2          2m15s
kube-system   local-path-provisioner-5cf85fd84d-q6lls   1/1     Running     0          2m14s
kube-system   metrics-server-5985cbc9d7-bsw7m           1/1     Running     0          2m14s
kube-system   svclb-traefik-87b72a09-lpzpf              2/2     Running     0          109s
kube-system   traefik-57b79cf995-mjxxm                  1/1     Running     0          109s
```

# Install GitOps
Git-controlled code delivery process with infrastructure and application definition as code, utilizing automation for updates and rollbacks.

- GitOps Principles: Entire system is described declaratively, desired system state is versioned in Git, and approved changes are automatically applied.
- GitOps Workflow: Git repository holds all configuration, cluster pulls changes, and GitOps controller matches Git state with cluster state.
- Benefits of GitOps: Provides version control, enables collaboration, improves security, and facilitates automation.

# Flux
## Installing Flux
- Flux needs to be installed on the cluster to facilitate the GitOps reconciliation loop
- Prerequisites: Kubernetes cluster and GitHub personal access token
### Creating a GitHub Personal Access Token
- Go to GitHub Settings > Developer Settings > Personal Access Tokens
- Generate a new classic token with 'repo' permissions
- Store the token in an environment variable: `export GITHUB_TOKEN=<your-token>`
- Also export your GitHub username: `export GITHUB_USER=<your-username>`
### Installing Flux CLI
- Various installation methods available (e.g., Homebrew, curl)
- Verify installation with `which flux`
### Checking Cluster Compatibility
- Run `flux check --pre` to ensure the cluster meets Flux requirements

After it passes:

```bash
# bryanlurer @ m4-mbp in ~/devops [7:39:05] 
$ flux check --pre
► checking prerequisites
✔ Kubernetes 1.31.4+k3s1 >=1.28.0-0
✔ prerequisites checks passed
```

### Bootstrapping Flux on the Cluster

- Use the command:
```bash
flux bootstrap github \
--owner=$GITHUB_USER \
--repository=homelab \
--branch=main \
--path=./clusters/staging \
--personal
```

Expected output:

```
# bryanlurer @ m4-mbp in ~/dev/homelab on git:main o [7:47:18] C:1
$ flux bootstrap github \
--owner=$GITHUB_USER \
--repository=homelab \
--branch=main \
--path=./clusters/staging \
--personal
► connecting to github.com
► cloning branch "main" from Git repository "https://github.com/blurer/homelab.git"
✔ cloned repository
► generating component manifests
✔ generated component manifests
✔ committed component manifests to "main" ("c318b6d1b72f70e2bd078109304d0b27dba691f8")
► pushing component manifests to "https://github.com/blurer/homelab.git"
► installing components in "flux-system" namespace
✔ installed components
✔ reconciled components
► determining if source secret "flux-system/flux-system" exists
► generating source secret
✔ public key: ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBKafcbxbdNyHlkdNvNjtdJFTWor9wLJMI3LpNC0zqC3DiTlu/jwVjzScGWT42AdW7R3MxHkoPrPMPGwxJ2KO8tMqRpBojdF3nab3/pfZyR/qFvsEfTYZzBFbxJMttDkkTg==
✔ configured deploy key "flux-system-main-flux-system-./clusters/staging" for "https://github.com/blurer/homelab"
► applying source secret "flux-system/flux-system"
✔ reconciled source secret
► generating sync manifests
✔ generated sync manifests
✔ committed sync manifests to "main" ("e6699cefd3cd13b5d8fd2ebbb4149b27fc0286c5")
► pushing sync manifests to "https://github.com/blurer/homelab.git"
► applying sync manifests
✔ reconciled sync configuration
◎ waiting for GitRepository "flux-system/flux-system" to be reconciled
✔ GitRepository reconciled successfully
◎ waiting for Kustomization "flux-system/flux-system" to be reconciled
✔ Kustomization reconciled successfully
► confirming components are healthy
✔ helm-controller: deployment ready
✔ kustomize-controller: deployment ready
✔ notification-controller: deployment ready
✔ source-controller: deployment ready
✔ all components are healthy
```


