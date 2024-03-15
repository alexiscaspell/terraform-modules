# AWS IAM New User Creator

The Terraform AWS IAM New User Creator Module is designed to create an AWS Identity and Access Management (IAM) user and manage the attachment of policies to that user. It provides the flexibility to attach existing policies by ARN and create and attach custom policies defined in JSON files to the IAM user.

This module creates and manages the following AWS resources:
- IAM User
- IAM User Policy Attachments (existing policies)
- IAM Policies (custom policies, if specified)

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | ~> 4.16 |

## Usage

Here's an example of how to use this module:

```hcl
module "iam_user" {
  source       = "git::https://github.com/alexiscaspell/terraform-modules.git//aws/new_user_creator?ref=main"
  aws_region   = "us-east-1"  # AWS region
  user_name    = "new_user"   # Name of the new IAM user
  policies     = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
  custom_policies = [
    { name = "custom-policy-1", path = "path/to/custom-policy-1.json" },
    { name = "custom-policy-2", path = "path/to/custom-policy-2.json" }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws_region | The AWS region in which to create the IAM user. | `string` | us-east-1 | no |
| user\_name | The name of the new IAM user to be created. | `string` | n/a | yes |
| policies | List of ARNs of existing policies to attach to the user. | `list(string)` | `[]` | no |
| custom_policies | List of custom policies to create and attach to the user. Each map should include "name" (the name of the policy) and "path" (the path to the JSON file defining the policy). | `list(map(string))` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| user\_arn | The ARN of the newly created IAM user. |
| access\_key\_details | A multiline string with details about the IAM user's access key, including user, access key ID, access key secret, status, and create date. |