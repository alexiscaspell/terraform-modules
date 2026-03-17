#!/bin/bash
set -euo pipefail

echo "=== Resetting Kubernetes node ==="

kubeadm reset -f 2>/dev/null || true

rm -rf /etc/cni/net.d
rm -rf /var/lib/etcd

USER_HOME=$(eval echo ~"${SUDO_USER:-$USER}")
rm -rf "${USER_HOME}/.kube"

iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X

echo "=== Node reset complete ==="
