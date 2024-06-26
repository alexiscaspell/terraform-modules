variable "name" {
  description = "Name of ArgoCD installation"
  default     = "argocd"
}
variable "argocd_version" {
  description = "Version of ArgoCD to install"
  default     = "latest"
}

variable "namespace" {
  description = "Namespace to install ArgoCD into"
  default     = "argocd"
}

variable "kubeconfig_path" {
  description = "Path of kubeconfig file"
  type        = string
}

variable "kube_context" {
  description = "Context of kubeconfig to use"
  type        = string
  default     = "default"
}

variable "sets" {
  description = "Variables of values.yaml to replace in Helm chart"
  type    = map
  default = {}
}

variable "repositories" {
  type  = list(object({
    name = string
    url = string
    password = string
  }))
  description = "List of Repositories to add to ArgoCD"
}

variable "applications" {
  type  = list(object({
    name = string
    repo_url = string
    path = string
    project = string
    namespace = string
  }))
  description = "List of Applications to add to ArgoCD"
}