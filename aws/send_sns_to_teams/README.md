# AWS Lambda Function from SNS to Teams

The Terraform AWS Lambda Function Module creates an AWS Lambda function that sends an SNS topic status to a Teams channel through a webhook.

## Prerequisites

Before using this module, ensure you have:

- AWS credentials configured.
- Terraform installed.

## Usage

Here's an example of how to use this module:

```hcl
module "lambda_function" {
  source                = "git::https://github.com/alexiscaspell/terraform-modules.git//aws/send_sns_to_teams?ref=main"
  lambda_function_name  = "MyLambdaFunction"
  lambda_timeout        = "15"
  retention_in_days     = "1"
  teams_webhook         = "https://teams.webhook.url"
  lambda_python_runtime = "python3.8"
}
```

## Inputs

| Name                    | Description                                           | Type           | Default | Required |
|-------------------------|-------------------------------------------------------|----------------|---------|:--------:|
| lambda_function_name    | Lambda function name.                                 | `string`       | n/a     | yes      |
| lambda_timeout          | Lambda function timeout in seconds.                  | `string`       | "15"    | no       |
| retention_in_days       | Lambda function logs retention in days.              | `string`       | "1"     | no       |
| teams_webhook           | Teams webhook.                                       | `string`       | n/a     | yes      |
| lambda_python_runtime   | Version of the runtime for Python Lambdas.           | `string`       | n/a     | yes      |

## Outputs

| Name            | Description             |
|-----------------|-------------------------|
| lambda_arn      | Lambda ARN.             |
| lambda_name     | Lambda function name.   |

## TODO
* Beautify the teams message sent. [(here you can see an example)](https://medium.com/@rajvirsinghrai/lambda-to-publish-aws-sns-event-on-ms-teams-channel-using-python-and-webhook-dd569d3ab6df)