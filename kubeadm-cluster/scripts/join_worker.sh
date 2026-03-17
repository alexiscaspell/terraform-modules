#!/bin/bash
set -euo pipefail

MASTER_HOST="${1:?Master host is required}"
MASTER_PORT="${2:-22}"
MASTER_USER="${3:?Master user is required}"
MASTER_PASSWORD="${4:?Master password is required}"

echo "=== Joining worker node to cluster ==="

apt-get install -y sshpass

# Clean up any previous installation
kubeadm reset -f 2>/dev/null || true
rm -rf /etc/cni/net.d

# Retrieve join command from control plane
echo "Fetching join command from master at ${MASTER_HOST}..."
JOIN_CMD=$(sshpass -p "${MASTER_PASSWORD}" ssh \
  -o StrictHostKeyChecking=no \
  -p "${MASTER_PORT}" \
  "${MASTER_USER}@${MASTER_HOST}" \
  'cat /tmp/kubeadm_join_command.sh')

echo "Joining cluster..."
${JOIN_CMD}

# Copy kubeconfig from control plane for convenience
USER_HOME=$(eval echo ~"${SUDO_USER:-$USER}")
mkdir -p "${USER_HOME}/.kube"
sshpass -p "${MASTER_PASSWORD}" scp \
  -o StrictHostKeyChecking=no \
  -P "${MASTER_PORT}" \
  "${MASTER_USER}@${MASTER_HOST}:/tmp/kubeadm_kubeconfig" \
  "${USER_HOME}/.kube/config"
chown "$(id -u "${SUDO_USER:-$USER}")":"$(id -g "${SUDO_USER:-$USER}")" "${USER_HOME}/.kube/config"

echo "=== Worker node successfully joined the cluster ==="
