# Terraform SSH Executor Module

Execute bash scripts on remote machines via SSH. Supports running the same or different scripts across multiple hosts in a single call.

## Usage

```hcl
module "ssh_executor" {
  source = "git::https://github.com/alexiscaspell/terraform-modules.git//ssh-execute?ref=main"

  executions = [
    {
      ssh_host     = "192.168.0.2"
      ssh_user     = "admin"
      ssh_password = "secret"
      script_path  = "path/to/script.sh"
    },
    {
      ssh_host        = "192.168.0.3"
      ssh_user        = "admin"
      ssh_password    = "secret"
      script_path     = "path/to/script.sh"
      local_directory = "path/to/files"
    }
  ]
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| `executions` | List of SSH execution configurations | `list(object)` | yes |

Each object in `executions` accepts:

| Field | Description | Type | Default | Required |
|-------|-------------|------|---------|:--------:|
| `ssh_host` | SSH host to connect to | `string` | — | yes |
| `ssh_port` | SSH port | `number` | `22` | no |
| `ssh_user` | SSH user | `string` | — | yes |
| `ssh_password` | SSH password | `string` | — | yes |
| `script_path` | Local path to the bash script to execute | `string` | — | yes |
| `script_arguments` | Arguments to pass to the script | `list(string)` | `[]` | no |
| `local_directory` | Local directory to copy to remote machine | `string` | `null` | no |
| `remote_directory` | Remote directory for copied files | `string` | `"/tmp"` | no |
| `delete_folder` | Delete copied folder after execution | `bool` | `true` | no |
| `delete_script` | Delete script file after execution | `bool` | `true` | no |

## Outputs

This module doesn't expose any outputs.
