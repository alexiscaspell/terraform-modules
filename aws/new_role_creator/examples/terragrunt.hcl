locals {
}

terraform {  
  source = "git::https://github.com/alexiscaspell/terraform-modules.git//aws/new_role_creator?ref=master"
}

inputs = {

    aws_region = "us-east-1"

    role_name      = "rol-prueba-iam" 
    policies       = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess","arn:aws:iam::aws:policy/AmazonAppStreamFullAccess"] 
    trust_policy   = "policies/trust_policy.json"
    custom_policies = [
    { name = "AsessmentPrueba", path = "policies/assessment_policy.json" },
    { name = "StorageGatewayPrueba", path = "policies/storage_gateway.json" }
  ]
}