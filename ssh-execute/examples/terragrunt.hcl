terraform {
  source = "git::https://github.com/alexiscaspell/terraform-modules.git//ssh-execute?ref=main"
}

inputs = {
  executions = [
    {
      ssh_host     = "192.168.0.2"
      ssh_port     = 22
      ssh_user     = "admin"
      ssh_password = "secret"
      script_path  = "/path/to/script.sh"
    },
    {
      ssh_host        = "192.168.0.3"
      ssh_port        = 22
      ssh_user        = "admin"
      ssh_password    = "secret"
      script_path     = "/path/to/script.sh"
      local_directory = "/path/to/files"
    }
  ]
}
