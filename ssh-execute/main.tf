provider "null" {}

locals {
  executions = {
    for idx, e in var.executions : tostring(idx) => merge(e, {
      parent_dir       = coalesce(e.remote_directory, "/tmp")
      execution_dir    = e.local_directory != null ? "${coalesce(e.remote_directory, "/tmp")}/${basename(e.local_directory)}" : coalesce(e.remote_directory, "/tmp")
      script_file_name = basename(e.script_path)
    })
  }
  exec_only     = { for k, e in local.executions : k => e if e.local_directory == null }
  exec_and_copy = { for k, e in local.executions : k => e if e.local_directory != null }
}

resource "null_resource" "ssh_executor" {
  for_each = local.exec_only

  triggers = {
    always_run = timestamp()
  }

  provisioner "file" {
    source      = each.value.script_path
    destination = "${each.value.execution_dir}/${each.value.script_file_name}"

    connection {
      type     = "ssh"
      host     = each.value.ssh_host
      port     = each.value.ssh_port
      user     = each.value.ssh_user
      password = each.value.ssh_password
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ${each.value.execution_dir}/${each.value.script_file_name}",
      "cd ${each.value.execution_dir} && ./${each.value.script_file_name} ${join(" ", each.value.script_arguments)}",
      "if [ '${each.value.delete_script}' = true ]; then rm ${each.value.execution_dir}/${each.value.script_file_name}; fi",
    ]

    connection {
      type     = "ssh"
      host     = each.value.ssh_host
      port     = each.value.ssh_port
      user     = each.value.ssh_user
      password = each.value.ssh_password
    }
  }
}

resource "null_resource" "ssh_executor_and_copy" {
  for_each = local.exec_and_copy

  triggers = {
    always_run = timestamp()
  }

  provisioner "file" {
    source      = each.value.local_directory
    destination = each.value.parent_dir

    connection {
      type     = "ssh"
      host     = each.value.ssh_host
      port     = each.value.ssh_port
      user     = each.value.ssh_user
      password = each.value.ssh_password
    }
  }

  provisioner "file" {
    source      = each.value.script_path
    destination = "${each.value.execution_dir}/${each.value.script_file_name}"

    connection {
      type     = "ssh"
      host     = each.value.ssh_host
      port     = each.value.ssh_port
      user     = each.value.ssh_user
      password = each.value.ssh_password
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ${each.value.execution_dir}/${each.value.script_file_name}",
      "cd ${each.value.execution_dir} && ./${each.value.script_file_name} ${join(" ", each.value.script_arguments)}",
      "if [ '${each.value.delete_script}' = true ]; then rm ${each.value.execution_dir}/${each.value.script_file_name}; fi",
      "if [ '${each.value.delete_folder}' = true ]; then rm -rf ${each.value.execution_dir}; fi"
    ]

    connection {
      type     = "ssh"
      host     = each.value.ssh_host
      port     = each.value.ssh_port
      user     = each.value.ssh_user
      password = each.value.ssh_password
    }
  }
}
