# AWS Glue Subnet Availability

The Terraform AWS Glue Subnet Availability Module simplifies the creation of AWS Glue network connections for multiple subnets. This module enables you to associate Glue connections with specific subnets, allowing you to manage connectivity to your data sources efficiently.

## Providers

| Name | Version |
|------|---------|
| aws  | ~> 4.16 |

## Usage

Here's an example of how to use this module:

```hcl
module "glue_subnet_connections" {
  source                  = "git::https://github.com/alexiscaspell/terraform-modules.git//aws/glue_subnets?ref=master"
  subnet_ids           = ["subnet-id-1", "subnet-id-2"]
  eks_worker_sg        = "sg-xxxxxxxxxxxxxxxxx"  # Replace with your EKS worker security group ID
  glue_connection_prefix = "custom-prefix-"
}
```

## Inputs

The following table lists the input variables accepted by this module:

| Name                   | Description                                                                                               | Type              | Default                  | Required |
|------------------------|-----------------------------------------------------------------------------------------------------------|-------------------|--------------------------|:--------:|
| `subnet_ids`           | List of subnet IDs to associate with Glue connections.                                                      | `list(string)`    | `[]`                     | yes      |
| `eks_worker_sg`        | ID of the security group associated with your EKS worker nodes.                                             | `string`          | n/a                      | yes      |
| `glue_connection_prefix`| Prefix for the names of the Glue network connections to be created.                                       | `string`          | `"subnet-availability-"` | no       |

## Outputs

The following table lists the output variables provided by this module:

| Name                       | Description                                                  |
|----------------------------|--------------------------------------------------------------|
| `subnet_availability_ids`  | List of Glue connection IDs representing subnet availability. |
