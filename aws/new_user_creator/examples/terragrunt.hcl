locals {
}

terraform {  
  source = "git::https://github.com/alexiscaspell/terraform-modules.git//aws/new_user_creator?ref=master"
}

inputs = {

    aws_region = "us-east-1"

    user_name      = "user-prueba-iam" 
    policies       = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess","arn:aws:iam::aws:policy/AmazonAppStreamFullAccess"] 
    custom_policies = [
    { name = "AsessmentPrueba", path = "policies/assessment_policy.json" },
    { name = "StorageGatewayPrueba", path = "policies/storage_gateway.json" }
  ]
}