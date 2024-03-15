locals {
}

terraform {  
  source = "git::https://github.com/alexiscaspell/terraform-modules.git//aws/alarm_to_sns?ref=main"
}

inputs = {
  aws_region            = "us-east-1" 

  dimensions            = {
    LoadBalancer = "app/un-lb/abcde1235"
  }
  alarm_name            = "LoadBalancer5xxAlarm"
  alarm_description     = "Alarma para Load Balancer en estado 5xx"
  namespace             = "AWS/ELB"
  metric_name           = "HTTPCode_Backend_5XX"
  threshold             = 1
  period                = 60
  evaluation_periods    = 1
  comparison_operator   = "GreaterThanOrEqualToThreshold"
  lambda_notification_arn = "soyunalambda"
}