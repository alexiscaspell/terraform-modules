locals {
}

terraform {  
  source = "git::https://github.com/alexiscaspell/terraform-modules.git//aws/glue_subnets?ref=main"
}

inputs = {
    subnet_ids              = ["subnet-id-1", "subnet-id-2"]
    eks_worker_sg           = "sg-xxxxxxxxxxxxxxxxx"  # Replace with your EKS worker security group ID
    glue_connection_prefix  = "custom-prefix-"
}