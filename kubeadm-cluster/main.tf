terraform {
  required_version = ">= 1.5"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
}

provider "null" {}

locals {
  scripts_path = "${path.module}/scripts"
}

# ==================== CONTROL PLANE ====================

resource "null_resource" "master_setup" {
  triggers = {
    always_run = timestamp()
  }

  connection {
    type     = "ssh"
    host     = var.master.host
    port     = var.master.port
    user     = var.master.user
    password = var.master.password
  }

  provisioner "file" {
    source      = "${local.scripts_path}/install_prerequisites.sh"
    destination = "/tmp/install_prerequisites.sh"
  }

  provisioner "file" {
    source      = "${local.scripts_path}/init_master.sh"
    destination = "/tmp/init_master.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_prerequisites.sh /tmp/init_master.sh",
      "sudo /tmp/install_prerequisites.sh '${var.kubernetes_version}'",
      "sudo /tmp/init_master.sh '${var.pod_network_cidr}' '${var.service_cidr}' '${var.api_server_san}'",
      "rm -f /tmp/install_prerequisites.sh /tmp/init_master.sh",
    ]
  }
}

# ==================== WORKER NODES ====================

resource "null_resource" "worker_setup" {
  for_each = { for idx, w in var.worker_nodes : tostring(idx) => w }

  depends_on = [null_resource.master_setup]

  triggers = {
    always_run = timestamp()
  }

  connection {
    type     = "ssh"
    host     = each.value.host
    port     = each.value.port
    user     = each.value.user
    password = each.value.password
  }

  provisioner "file" {
    source      = "${local.scripts_path}/install_prerequisites.sh"
    destination = "/tmp/install_prerequisites.sh"
  }

  provisioner "file" {
    source      = "${local.scripts_path}/join_worker.sh"
    destination = "/tmp/join_worker.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_prerequisites.sh /tmp/join_worker.sh",
      "sudo /tmp/install_prerequisites.sh '${var.kubernetes_version}'",
      "sudo /tmp/join_worker.sh '${var.master.host}' '${var.master.port}' '${var.master.user}' '${var.master.password}'",
      "rm -f /tmp/install_prerequisites.sh /tmp/join_worker.sh",
    ]
  }
}

# ==================== FETCH KUBECONFIG ====================

resource "null_resource" "fetch_kubeconfig" {
  count      = var.kubeconfig_path != null ? 1 : 0
  depends_on = [null_resource.master_setup]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      set -e
      command -v sshpass > /dev/null 2>&1 || sudo apt-get install -y sshpass
      _DEST=$(eval echo '${var.kubeconfig_path}')
      mkdir -p "$(dirname "$_DEST")"
      sshpass -p '${var.master.password}' scp -o StrictHostKeyChecking=no -P ${var.master.port} ${var.master.user}@${var.master.host}:~/.kube/config "$_DEST"
    EOT
  }
}
