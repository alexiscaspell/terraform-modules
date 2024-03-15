provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
    config_context = var.kube_context
  }
}

resource "helm_release" "argocd" {
  chart      = "argo-cd"
  name       = var.name
  namespace  = var.namespace
  create_namespace = true
  repository = "oci://registry-1.docker.io/bitnamicharts"
  version  = var.argocd_version

  dynamic "set" {
    for_each = var.sets
    content {
      name  = set.key
      value = set.value
    }
  }
}