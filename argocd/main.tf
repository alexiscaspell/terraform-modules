terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubectl" {
    load_config_file = true
    config_path = var.kubeconfig_path
    config_context = var.kube_context
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
    config_context = var.kube_context
  }
}

resource "kubectl_manifest" "argocd_repository" {
    count = length(var.repositories)

    yaml_body = <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: ${var.repositories[count.index].name}
  namespace: ${var.namespace}
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: ${var.repositories[count.index].url}
  password: ${var.repositories[count.index].password}
EOF
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
