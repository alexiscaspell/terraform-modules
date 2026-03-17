#!/bin/bash
set -euo pipefail

POD_NETWORK_CIDR="${1:-10.244.0.0/16}"
SERVICE_CIDR="${2:-10.96.0.0/12}"
API_SERVER_SAN="${3:-}"

echo "=== Initializing Kubernetes control plane ==="

# Clean up any previous installation
kubeadm reset -f 2>/dev/null || true
rm -rf /etc/cni/net.d /var/lib/etcd

USER_HOME=$(eval echo ~"${SUDO_USER:-$USER}")
rm -rf "${USER_HOME}/.kube"

# Build kubeadm init arguments
INIT_ARGS="--pod-network-cidr=${POD_NETWORK_CIDR} --service-cidr=${SERVICE_CIDR}"

if [ -n "$API_SERVER_SAN" ]; then
  INIT_ARGS="${INIT_ARGS} --apiserver-cert-extra-sans=${API_SERVER_SAN} --control-plane-endpoint=${API_SERVER_SAN}"
fi

kubeadm init ${INIT_ARGS}

# Configure kubeconfig for the SSH user
mkdir -p "${USER_HOME}/.kube"
cp -f /etc/kubernetes/admin.conf "${USER_HOME}/.kube/config"
chown "$(id -u "${SUDO_USER:-$USER}")":"$(id -g "${SUDO_USER:-$USER}")" "${USER_HOME}/.kube/config"

# Install Flannel CNI
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

echo "Waiting for control plane node to become Ready..."
for i in $(seq 1 60); do
  if kubectl get nodes 2>/dev/null | grep -q " Ready"; then
    echo "Control plane is Ready!"
    break
  fi
  echo "  Attempt ${i}/60 - waiting 5s..."
  sleep 5
done

kubectl get nodes

# Save join command for workers
kubeadm token create --print-join-command > /tmp/kubeadm_join_command.sh
chmod 644 /tmp/kubeadm_join_command.sh

# Save kubeconfig for external/remote access
cp /etc/kubernetes/admin.conf /tmp/kubeadm_kubeconfig
chmod 644 /tmp/kubeadm_kubeconfig

if [ -n "$API_SERVER_SAN" ]; then
  sed -i "s|server: https://.*:6443|server: https://${API_SERVER_SAN}:6443|" /tmp/kubeadm_kubeconfig
fi

echo "=== Control plane initialization complete ==="
