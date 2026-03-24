variable "master" {
  type = object({
    host     = string
    port     = optional(number, 22)
    user     = string
    password = string
  })
  description = "Control plane node SSH connection details"
}

variable "worker_nodes" {
  type = list(object({
    host     = string
    port     = optional(number, 22)
    user     = string
    password = string
  }))
  description = "Worker nodes SSH connection details"
  default     = []
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to install (major.minor, e.g. 1.31)"
  default     = "1.31"
}

variable "pod_network_cidr" {
  type        = string
  description = "CIDR for the pod network (must be 10.244.0.0/16 when using Flannel)"
  default     = "10.244.0.0/16"
}

variable "service_cidr" {
  type        = string
  description = "CIDR for Kubernetes services"
  default     = "10.96.0.0/12"
}

variable "api_server_san" {
  type        = string
  description = "Additional SAN for the API server certificate (hostname or IP for external access)"
  default     = ""
}

variable "cluster_name" {
  type        = string
  description = "Name identifier for the cluster"
  default     = "kubernetes"
}

variable "kubeconfig_path" {
  type        = string
  description = "Local path to save the kubeconfig file. Requires sshpass or expect on the Terraform runner. Set to null to skip."
  default     = null
}
