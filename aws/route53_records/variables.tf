variable "records" {
  type  = list(object({
    name      = string
    alias     = optional(bool)
    values    = list(string)
    dns_type  = string
    zone_id   = optional(string)
    ttl       = optional(number)
  }))
  description = "List of DNS records to be added to the Route 53 hosted zone"
}

variable "hosted_zone_id" {
  type        = string
  description = "ID of the existing Route 53 hosted zone"
}
