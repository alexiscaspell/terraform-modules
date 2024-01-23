locals {
  alias_records = [for record in var.records : record if lookup(record, "alias", false)==true]
  non_alias_records = [for record in var.records : record if lookup(record, "alias", false)!=true]
}

resource "aws_route53_record" "dns_records_wo_alias" {
  count = length(local.non_alias_records)

  name    = local.non_alias_records[count.index].name
  type    = local.non_alias_records[count.index].dns_type
  ttl     = local.non_alias_records[count.index].ttl
  zone_id = var.hosted_zone_id

  records = local.non_alias_records[count.index].values
}

resource "aws_route53_record" "dns_records_w_alias" {
  count = length(local.alias_records)

  name    = local.alias_records[count.index].name
  type    = local.alias_records[count.index].dns_type
  zone_id = var.hosted_zone_id

  alias {
    name                   = local.alias_records[count.index].values[0]
    zone_id                = local.alias_records[count.index].zone_id
    evaluate_target_health = true
  }
}