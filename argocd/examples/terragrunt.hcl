locals {
}

terraform {  
  source = "git::https://github.com/alexiscaspell/terraform-modules.git//argocd?ref=main"
}

inputs = {
  argocd_version = "5.10.5"
  namespace    = "argocd"
  kubeconfig_path = "~/.kube/config"
  kube_context = "default"
}