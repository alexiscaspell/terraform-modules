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