locals {
}

terraform {  
  source = "git::https://github.com/alexiscaspell/terraform-modules.git//ssh-execute?ref=main"
}

inputs = {
    ssh_host            = "your_ssh_host"
    ssh_port            = 22
    ssh_user            = "your_ssh_user"
    ssh_password        = "your_ssh_pass"
    script_path         = "./example.sh"
  }