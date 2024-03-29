provider "null" {}

locals {
  parent_dir = var.remote_directory!=null ? var.remote_directory : "/tmp"
  execution_dir = var.local_directory!=null ? "${local.parent_dir}/${basename(var.local_directory)}" : local.parent_dir
  script_file_name = basename(var.script_path)
}


resource "null_resource" "ssh_executor" {

  count = var.local_directory!=null ? 0 : 1 

  triggers = {
    always_run = timestamp()
  }

  provisioner "file" {
    source      = var.script_path
    destination = "${local.execution_dir}/${basename(var.script_path)}"

    connection {
      type        = "ssh"
      user        = var.ssh_user
      host        = var.ssh_host
      port     = var.ssh_port
      password = var.ssh_password
    }
  }
  
  provisioner "remote-exec" {

    inline = [
      "chmod +x ${local.execution_dir}/${local.script_file_name}",
      "cd ${local.execution_dir} && ./${local.script_file_name} ${join(" ",var.script_arguments)}",
      "if [ '${var.delete_script}' = true ]; then rm ${local.execution_dir}/${local.script_file_name}; fi",
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      host        = var.ssh_host
      port     = var.ssh_port
      password = var.ssh_password
    }
  }

}

resource "null_resource" "ssh_executor_and_copy" {
  count = var.local_directory!=null ? 1 : 0 

  triggers = {
    always_run = timestamp()
  }

  provisioner "file" {
    source      = var.local_directory
    destination = local.parent_dir

    connection {
      type        = "ssh"
      user        = var.ssh_user
      host        = var.ssh_host
      port     = var.ssh_port
      password = var.ssh_password
    }
  }

  provisioner "file" {
    source      = var.script_path
    destination = "${local.execution_dir}/${local.script_file_name}"

    connection {
      type        = "ssh"
      user        = var.ssh_user
      host        = var.ssh_host
      port     = var.ssh_port
      password = var.ssh_password
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ${local.execution_dir}/${local.script_file_name}",
      "cd ${local.execution_dir} && ./${local.script_file_name} ${join(" ",var.script_arguments)}",
      "if [ '${var.delete_script}' = true ]; then rm ${local.execution_dir}/${local.script_file_name}; fi",
      "if [ '${var.delete_folder}' = true ]; then rm -rf ${local.execution_dir}; fi"
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      host        = var.ssh_host
      port     = var.ssh_port
      password = var.ssh_password
    }
  }

}
