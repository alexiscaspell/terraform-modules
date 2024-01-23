provider "null" {}

resource "null_resource" "ssh_executor" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "remote-exec" {
    inline = [
      file(var.script_path)
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
