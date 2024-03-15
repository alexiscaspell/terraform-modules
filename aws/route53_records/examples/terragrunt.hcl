locals {
}

terraform {  
  source = "git::https://github.com/alexiscaspell/terraform-modules.git//aws/route53_records?ref=main"
}

inputs = {

    aws_region = "us-east-1"
    hosted_zone_id  = "hosted_zone_test"

    records       = [
        {
        name      = "ejemplo1.dev.nose.tk"
        dns_type  = "A"
        ttl       = 300
        values    = ["192.168.0.14"]
        },
        {
        name      = "ejemplo2.dev.nose.tk"
        dns_type  = "CNAME"
        ttl       = 300
        values    = ["www.google.com"]
        }
  ]
}