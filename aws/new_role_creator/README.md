# AWS IAM New Role Creator

The Terraform AWS IAM New Role Creator Module is designed to create an AWS Identity and Access Management (IAM) role and manage the attachment of policies to that role. It provides the flexibility to attach existing policies by ARN and create and attach custom policies defined in JSON files to the IAM role.

This module creates and manages the following AWS resources:
- IAM Role
- IAM Role Policy Attachments (existing policies)
- IAM Policies (custom policies, if specified)

## Providers

| Name    | Version |
|---------|---------|
| aws     | ~> 4.16 |

## Usage

Here's an example of how to use this module:

```hcl
module "iam_role" {
  source           = "git::https://github.com/alexiscaspell/terraform-modules.git//aws/new_role_creator?ref=master"
  aws_region       = "us-east-1"  # AWS region
  role_name        = "new_role"   # Name of the new IAM role
  trust_policy = "path/to/trust-policy.json"
  policies         = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
  custom_policies  = [
    { name = "custom-policy-1", path = "path/to/custom-policy-1.json" },
    { name = "custom-policy-2", path = "path/to/custom-policy-2.json" }
  ]
}
```

## Inputs

| Name            | Description                                           | Type           | Default     | Required |
|-----------------|-------------------------------------------------------|----------------|-------------|:--------:|
| aws_region      | The AWS region in which to create the IAM role.       | `string`       | us-east-1   | no       |
| role_name       | The name of the new IAM role to be created.           | `string`       | n/a         | yes      |
| policies        | List of ARNs of existing policies to attach to the role. | `list(string)` | `[]`        | no       |
| custom_policies | List of custom policies to create and attach to the role. Each map should include "name" (the name of the policy) and "path" (the path to the JSON file defining the policy). | `list(map(string))` | `[]` | no |
| trust_policy   | Json path with the role trust policy.         | `string`  | n/a | yes |

## Outputs

| Name         | Description                                       |
|--------------|---------------------------------------------------|
| role_arn     | The ARN of the newly created IAM role.            |

