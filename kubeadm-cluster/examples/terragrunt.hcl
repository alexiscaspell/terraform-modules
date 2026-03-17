terraform {
  source = "git::https://github.com/alexiscaspell/terraform-modules.git//kubeadm-cluster?ref=main"
}

inputs = {
  master = {
    host     = "192.168.0.2"
    port     = 22
    user     = "admin"
    password = "secret"
  }

  worker_nodes = [
    {
      host     = "192.168.0.3"
      port     = 22
      user     = "admin"
      password = "secret"
    }
  ]

  kubernetes_version = "1.31"
  api_server_san     = "k8s.example.com"
  cluster_name       = "my-cluster"
  kubeconfig_path    = "~/.kube/my-cluster"
}
