# Terraform SSH Executor Module

The Terraform SSH Executor Module allows you to execute a bash script on a remote machine via SSH. It provides the flexibility to customize the SSH connection details and the script to execute.

## Usage

Here's an example of how to use this module:

```hcl
module "ssh_executor" {
  source       = "git::https://github.com/alexiscaspell/terraform-ssh-executor.git//ssh-execute?ref=main"
  ssh_host     = "example.com"  # SSH host to connect to
  ssh_user     = "username"     # SSH user for authentication
  ssh_password = "password"     # SSH password for authentication
  ssh_port     = 2222            # SSH port to connect to
  script_path  = "path/to/script.sh"  # Path of the bash script to execute on the remote machine
}
```

## Inputs

| Name           | Description                                      | Type    | Default | Required |
|----------------|--------------------------------------------------|---------|---------|:--------:|
| ssh_host       | SSH host to connect to                           | `string`| n/a     | yes      |
| ssh_port       | SSH port to connect to                           | `number`| 22      | no       |
| ssh_user       | SSH user for authentication                      | `string`| n/a     | yes      |
| ssh_password   | SSH password for authentication                  | `string`| n/a     | yes      |
| script_path    | Path of the bash script to execute on the remote machine | `string` | n/a | yes |

## Outputs

This module doesn't expose any outputs.

