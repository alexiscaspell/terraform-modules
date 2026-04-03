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

# ---- Base packages (conntrack required by kubeadm preflight) ----
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y \
  apt-transport-https ca-certificates curl gnupg lsb-release conntrack

# ---- Install containerd ----
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y containerd.io

# ---- (Re)configure containerd with SystemdCgroup ----
# Always regenerate config to ensure it's correct regardless of previous state
systemctl stop containerd 2>/dev/null || true
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

systemctl enable containerd
systemctl restart containerd

# ---- Wait for containerd socket to be ready ----
echo "Waiting for containerd socket..."
for i in $(seq 1 30); do
  if systemctl is-active --quiet containerd && [ -S /var/run/containerd/containerd.sock ]; then
    echo "containerd is ready (attempt ${i}/30)."
    break
  fi
  if [ "$i" -eq 30 ]; then
    echo "ERROR: containerd did not become ready after 60s"
    systemctl status containerd --no-pager || true
    exit 1
  fi
  sleep 2
done

# ---- Install kubeadm, kubelet, kubectl ----
curl -fsSL "https://pkgs.k8s.io/core:/stable:/v${KUBERNETES_VERSION}/deb/Release.key" \
  | gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
  https://pkgs.k8s.io/core:/stable:/v${KUBERNETES_VERSION}/deb/ /" \
  > /etc/apt/sources.list.d/kubernetes.list

apt-get update -qq
# Unhold before installing in case of version change
apt-mark unhold kubelet kubeadm kubectl 2>/dev/null || true
DEBIAN_FRONTEND=noninteractive apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

systemctl enable kubelet

echo "=== Prerequisites installed successfully ==="
