locals {
}

terraform {  
  source = "git::https://github.com/alexiscaspell/terraform-ssh-executor.git//ssh-execute?ref=master"
}

inputs = {
    ssh_host            = "your_ssh_host"
    ssh_port            = 22
    ssh_user            = "your_ssh_user"
    ssh_password        = "your_ssh_pass"
    script_path         = "./example.sh"
  }