locals {
}

terraform {  
  source = "git::https://github.com/alexiscaspell/terraform-modules.git//aws/send_sns_to_teams?ref=main"
}

inputs = {
  aws_region            = "us-east-1" 

  lambda_function_name   = "my-lambda-function"
  lambda_timeout         = "15"
  retention_in_days      = "1"
  teams_webhook          = "https://my-webhook/12134546"
  lambda_python_runtime  = "python3.8"
}