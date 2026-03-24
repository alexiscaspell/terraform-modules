# kubeadm-cluster

Terraform module to provision a Kubernetes cluster using **kubeadm** with **containerd** as the container runtime and **Flannel** as the CNI plugin.

## Features

- **kubeadm** — Official Kubernetes cluster bootstrapping tool
- **containerd** — Lightweight container runtime (no Docker dependency)
- **Flannel** — Simple and lightweight CNI plugin
- **SystemdCgroup** — Proper cgroup driver for systemd-based systems
- **Multi-node** — One control plane + N worker nodes
- **Idempotent** — Resets previous installations before provisioning

## Prerequisites

- Ubuntu/Debian-based target nodes
- SSH access with password authentication to all nodes
- Target nodes must have internet access

## Usage

```hcl
module "kubernetes" {
  source = "git::https://github.com/alexiscaspell/terraform-modules.git//kubeadm-cluster?ref=main"

  master = {
    host     = "192.168.0.2"
    port     = 22
    user     = "admin"
    password = "secret"
  }

  worker_nodes = [
    {
      host     = "192.168.0.3"
      port     = 22
      user     = "admin"
      password = "secret"
    }
  ]

  kubernetes_version = "1.31"
  api_server_san     = "k8s.example.com"
  cluster_name       = "my-cluster"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `master` | Control plane node SSH connection | `object({host, port, user, password})` | — | yes |
| `worker_nodes` | Worker nodes SSH connections | `list(object({host, port, user, password}))` | `[]` | no |
| `kubernetes_version` | Kubernetes version (`major.minor`) | `string` | `"1.31"` | no |
| `pod_network_cidr` | Pod network CIDR (Flannel requires `10.244.0.0/16`) | `string` | `"10.244.0.0/16"` | no |
| `service_cidr` | Service network CIDR | `string` | `"10.96.0.0/12"` | no |
| `api_server_san` | Extra SAN for API server cert (for external access) | `string` | `""` | no |
| `cluster_name` | Cluster identifier | `string` | `"kubernetes"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `master_host` | Control plane node host |
| `api_server_endpoint` | Kubernetes API server endpoint |

## Kubeconfig

After provisioning, the kubeconfig is available on the master at `~/.kube/config`. To copy it locally:

```bash
scp user@master-host:~/.kube/config ~/.kube/my-cluster
```

## Architecture

```
┌─────────────────────────────────────────────────────┐
│  Terraform Runner (your machine)                    │
│                                                     │
│  1. SSH → master: install prereqs + kubeadm init    │
│  2. SSH → workers: install prereqs + kubeadm join   │
└─────────────────────────────────────────────────────┘

┌──────────────┐         ┌──────────────┐
│ Control Plane│         │   Worker N   │
│              │◄────────│              │
│  kubeadm     │  join   │  kubeadm     │
│  containerd  │         │  containerd  │
│  kubelet     │         │  kubelet     │
│  Flannel CNI │         │  Flannel CNI │
└──────────────┘         └──────────────┘
```

## Reset

To reset a node, upload and execute `scripts/reset_node.sh` on the target:

```bash
sudo bash reset_node.sh
```
