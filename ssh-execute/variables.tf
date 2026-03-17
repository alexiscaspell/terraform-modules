variable "executions" {
  type = list(object({
    ssh_host         = string
    ssh_port         = optional(number, 22)
    ssh_user         = string
    ssh_password     = string
    script_path      = string
    script_arguments = optional(list(string), [])
    local_directory  = optional(string)
    remote_directory = optional(string)
    delete_folder    = optional(bool, true)
    delete_script    = optional(bool, true)
  }))
  description = "List of SSH execution configurations. Each item defines a host connection and the script to run on it."
}
