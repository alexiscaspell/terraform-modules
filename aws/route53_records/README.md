# Route53 Records

The Terraform AWS Route 53 Records Module simplifies the management of DNS records in an existing AWS Route53 hosted zone. This module supports the addition of various types of DNS records, including A, CNAME, and MX records.

## Providers

| Name | Version |
|------|---------|
| aws  | ~> 4.16 |

## Usage

Here's an example of how to use this module:

```hcl
module "route53_dns" {
  source          = "git::https://github.com/alexiscaspell/terraform-modules.git//aws/route53_records?ref=master"

  hosted_zone_id  = "your-route53-hosted-zone-id"

  records         = [
    {
      name      = "example.com"
      dns_type  = "A"
      ttl       = 300
      values    = ["1.2.3.4"]
    },
    {
      name      = "www.example.com"
      dns_type  = "CNAME"
      ttl       = 300
      values    = ["example.com"]
    },
    {
      name      = "mail.example.com"
      dns_type  = "MX"
      ttl       = 300
      values    = ["10 mail-server.example.com"]
    },
    // Add more records as needed
  ]
}
```

## Inputs

| Name           | Description                                               | Type               | Default | Required |
|----------------|-----------------------------------------------------------|--------------------|---------|:--------:|
| records        | List of DNS records to be added to the Route 53 hosted zone. Each record is represented as an object with the following attributes: name, alias, values, dns_type, zone_id, and ttl. | `list(object)` | `[]`    | yes      |
| hosted_zone_id | The ID of the existing Route 53 hosted zone.              | `string`           | n/a     | yes      |

### Variables

#### `records`

- Type: `list(object)`
- Description: List of DNS records to be added to the Route 53 hosted zone. Each record is represented as an object with the following attributes:
  - `name` (string): The name of the DNS record.
  - `alias` (bool, optional): Whether the record is an alias. Defaults to `false`.
  - `values` (list(string)): The values associated with the DNS record.
  - `dns_type` (string): The type of DNS record (e.g., A, CNAME, MX).
  - `zone_id` (string, optional): The ID of the hosted zone of the alias record. Defaults to `null`.
  - `ttl` (number, optional): The time-to-live for the DNS record. Defaults to `null`.

#### `hosted_zone_id`

- Type: `string`
- Description: ID of the existing Route 53 hosted zone.

## Outputs
Without Outputs