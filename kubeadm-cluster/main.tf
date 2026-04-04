terraform {
  required_version = ">= 1.5"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0"
    }
  }
}

provider "null" {}

locals {
  scripts_path = "${path.module}/scripts"

  # Triggers re-provisioning only when scripts or key inputs change.
  # Use 'terraform taint' to force a full re-run manually.
  master_trigger = sha256(join("", [
    filesha256("${local.scripts_path}/install_prerequisites.sh"),
    filesha256("${local.scripts_path}/init_master.sh"),
    var.kubernetes_version,
    var.pod_network_cidr,
    var.service_cidr,
    var.api_server_san,
    var.master.host,
  ]))

  worker_triggers = {
    for idx, w in var.worker_nodes : tostring(idx) => sha256(join("", [
      filesha256("${local.scripts_path}/install_prerequisites.sh"),
      filesha256("${local.scripts_path}/join_worker.sh"),
      var.kubernetes_version,
      w.host,
      local.master_trigger,
    ]))
  }
}

# ==================== CONTROL PLANE ====================

resource "null_resource" "master_setup" {
  triggers = {
    config = local.master_trigger
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
      "sudo bash -e /tmp/install_prerequisites.sh '${var.kubernetes_version}'; echo $? > /tmp/_exit; test $(cat /tmp/_exit) -eq 0",
      "sudo bash -e /tmp/init_master.sh '${var.pod_network_cidr}' '${var.service_cidr}' '${var.api_server_san}'; echo $? > /tmp/_exit; test $(cat /tmp/_exit) -eq 0",
      "rm -f /tmp/install_prerequisites.sh /tmp/init_master.sh /tmp/_exit",
    ]
  }
}

# ==================== WORKER NODES ====================

resource "null_resource" "worker_setup" {
  for_each = { for idx, w in var.worker_nodes : tostring(idx) => w }

  depends_on = [null_resource.master_setup]

  triggers = {
    config = local.worker_triggers[each.key]
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
      "sudo bash -e /tmp/install_prerequisites.sh '${var.kubernetes_version}'; echo $? > /tmp/_exit; test $(cat /tmp/_exit) -eq 0",
      "sudo bash -e /tmp/join_worker.sh '${var.master.host}' '${var.master.port}' '${var.master.user}' '${var.master.password}'; echo $? > /tmp/_exit; test $(cat /tmp/_exit) -eq 0",
      "rm -f /tmp/install_prerequisites.sh /tmp/join_worker.sh /tmp/_exit",
    ]
  }
}

# ==================== FETCH KUBECONFIG ====================

resource "null_resource" "fetch_kubeconfig" {
  count      = var.kubeconfig_path != null ? 1 : 0
  depends_on = [null_resource.master_setup]

  triggers = {
    master = local.master_trigger
  }

  provisioner "local-exec" {
    command = <<-EOT
      set -e
      _DEST=$(eval echo '${var.kubeconfig_path}')
      mkdir -p "$(dirname "$_DEST")"
      if command -v sshpass > /dev/null 2>&1; then
        sshpass -p '${var.master.password}' \
          scp -o StrictHostKeyChecking=no -P ${var.master.port} \
          ${var.master.user}@${var.master.host}:~/.kube/config "$_DEST"
      elif command -v expect > /dev/null 2>&1; then
        expect -c "
          spawn scp -o StrictHostKeyChecking=no -P ${var.master.port} \
            ${var.master.user}@${var.master.host}:~/.kube/config $_DEST
          expect {
            \"yes/no\"   { send \"yes\r\"; exp_continue }
            \"password:\" { send \"${var.master.password}\r\" }
          }
          expect eof
        "
      else
        echo "ERROR: neither sshpass nor expect found."
        echo "  macOS:  expect is built-in, should be available."
        echo "  Ubuntu: sudo apt-get install -y sshpass"
        exit 1
      fi
    EOT
  }
}

data "local_sensitive_file" "kubeconfig" {
  count    = var.kubeconfig_path != null ? 1 : 0
  filename = pathexpand(var.kubeconfig_path)

  depends_on = [null_resource.fetch_kubeconfig]
}
