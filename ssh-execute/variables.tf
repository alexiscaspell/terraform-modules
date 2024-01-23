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
