# Terraform Helm ArgoCD Module

The Terraform Helm ArgoCD Module allows you to install ArgoCD on a Kubernetes cluster using Helm. It provides flexibility to customize the installation with different versions and configuration options.

## Usage

Here's an example of how to use this module:

```hcl
module "argocd" {
  source           = "./argocd"
  name             = "argocd"  # Name of the ArgoCD installation
  argocd_version   = "2.1.2"   # Version of ArgoCD to install
  namespace        = "argocd"  # Namespace to install ArgoCD into
  kubeconfig_path  = "/path/to/your/kubeconfig"  # Path of the kubeconfig file
  kube_context     = "default"  # Context of kubeconfig to use
}
```

## Inputs

| Name             | Description                                       | Type    | Default | Required |
|------------------|---------------------------------------------------|---------|---------|:--------:|
| name             | Name of the ArgoCD installation                   | `string`| argocd  | no       |
| argocd_version   | Version of ArgoCD to install                      | `string`| latest  | no       |
| namespace        | Namespace to install ArgoCD into                  | `string`| argocd  | no       |
| kubeconfig_path  | Path of the kubeconfig file                       | `string`| n/a     | yes      |
| kube_context     | Context of kubeconfig to use                      | `string`| default | no       |
| sets             | Variables of values.yaml to replace in Helm chart | `map`   | `{}`    | no       |

## Outputs

This module doesn't expose any outputs.