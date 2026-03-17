#!/bin/bash
set -euo pipefail

KUBERNETES_VERSION="${1:-1.31}"

echo "=== Installing Kubernetes v${KUBERNETES_VERSION} prerequisites ==="

# ---- Disable swap (required by kubelet) ----
swapoff -a
sed -i '/\sswap\s/d' /etc/fstab

# ---- Kernel modules for container networking ----
cat > /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# ---- Sysctl params for bridged traffic and IP forwarding ----
cat > /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

# ---- Install containerd ----
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y containerd.io

# SystemdCgroup driver is required for kubeadm with systemd-based distros
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

systemctl restart containerd
systemctl enable containerd

# ---- Install kubeadm, kubelet, kubectl ----
curl -fsSL "https://pkgs.k8s.io/core:/stable:/v${KUBERNETES_VERSION}/deb/Release.key" \
  | gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
  https://pkgs.k8s.io/core:/stable:/v${KUBERNETES_VERSION}/deb/ /" \
  > /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

systemctl enable kubelet

echo "=== Prerequisites installed successfully ==="
