variable "ssh_host" {
  type        = string
  description = "SSH host to connect to"
}

variable "ssh_port" {
  type        = number
  description = "SSH port to connect to"
  default     = 22
}

variable "ssh_user" {
  type        = string
  description = "SSH user for authentication"
}

variable "ssh_password" {
  type        = string
  description = "SSH password for authentication"
}

variable "script_path" {
  type        = string
  description = "Path of bash script to execute on the remote machine"
}

variable "local_directory" {
  type        = string
  description = "Path of local directory to copy to remote machine"
  default     = null
}

variable "remote_directory" {
  type        = string
  description = "Path of remote directory to copy the directory of local machine"
  default     = null
}

variable "script_arguments" {
  description = "Arguments to pass to the script"
  type        = list(string)
  default     = []
}

variable "delete_folder" {
  description = "If true deletes folder copied after script execution"
  type        = bool
  default     = true
}

variable "delete_script" {
  description = "If true deletes script file copied after execution"
  type        = bool
  default     = true
}
