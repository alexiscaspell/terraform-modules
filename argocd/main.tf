terraform {
  required_version = ">= 1.12"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.37.0"
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path = var.kubeconfig_path
  }
}

provider "kubectl" {
    load_config_file = true
    config_path = var.kubeconfig_path
    config_context = var.kube_context
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

# provider "helm" {
#   kubernetes {
#     config_path = var.kubeconfig_path
#     config_context = var.kube_context
#   }
# }

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

  depends_on = [ helm_release.argocd ]
}

resource "kubectl_manifest" "argocd_application" {
    count = length(var.applications)

    yaml_body = <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${var.applications[count.index].name}
  namespace: ${var.namespace}
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  destination:
    server: https://kubernetes.default.svc
    namespace: ${var.applications[count.index].namespace}
  project: ${var.applications[count.index].project}
  source:
    path: ${var.applications[count.index].path}
    repoURL: ${var.applications[count.index].repo_url}
    targetRevision: HEAD
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF

    depends_on = [ helm_release.argocd , kubectl_manifest.argocd_repository]
}

resource "helm_release" "argocd" {
  provider = helm
  chart      = "argo-cd"
  name       = var.name
  namespace  = var.namespace
  create_namespace = true
  repository = "oci://registry-1.docker.io/bitnamicharts"
  version  = var.argocd_version

  # recreate_pods = true
  # force_update  = true
  atomic        = true
  wait          = false
  replace       = true

  set = [
    for key, value in var.sets : {
      name  = key
      value = value
    }
  ]
}

