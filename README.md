# Homelab with K3s

Using Ubuntu 22.04 bare metal
Flux for gitops

## Hosted apps
- WIP

## To do
- Linkding
- Cloudflare DDNS
- Reverse proxy
- Dashboard (homepage)
- Mealie (recipes)
- Postgres
- Grafana
- Uptime Kuma
- Smokeping
- Wiki

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

## Flux 
