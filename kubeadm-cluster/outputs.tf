output "kubeconfig_path" {
  value       = var.kubeconfig_path
  description = "Path to the fetched kubeconfig file"
}

output "master_host" {
  value       = var.master.host
  description = "Control plane node host"
}

output "api_server_endpoint" {
  value       = "https://${coalesce(var.api_server_san, var.master.host)}:6443"
  description = "Kubernetes API server endpoint"
}
