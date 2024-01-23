# AWS CloudWatch Alarm To SNS Creator

This module enables the creation of AWS CloudWatch Metric Alarms with associated resources for notifications. It allows users to define alarms based on specific metrics, set thresholds, and receive notifications through SNS topics with a lambda associated.

## Providers

| Name | Version |
|------|---------|
| aws  | ~> 3.0  |

## Usage

Here's an example of how to use this module:

```hcl
module "cloudwatch_alarm" {
  source                  = "git::https://github.com/alexiscaspell/terraform-modules.git//aws/alarm_to_sns?ref=master"
  aws_region              = "us-east-1"  # AWS region
  dimensions              = {
    key1 = "value1"
    key2 = "value2"
  }
  topic_prefix            = "MyTopicPrefix"
  statistic               = "Sum"
  alarm_name              = "MyAlarm"
  alarm_description       = "Description of my alarm"
  namespace               = "AWS/EC2"
  metric_name             = "CPUUtilization"
  threshold               = "90"
  period                  = "300"
  evaluation_periods      = "3"
  comparison_operator     = "GreaterThanOrEqualToThreshold"
  lambda_notification_arn = "arn:aws:lambda:us-east-1:123456789012:function:MyLambdaFunction"
}
```

## Inputs

| Name                   | Description                                           | Type           | Default    | Required |
|------------------------|-------------------------------------------------------|----------------|------------|:--------:|
| aws_region             | The AWS region in which to create the CloudWatch alarm.| `string`       | us-east-1  | no       |
| dimensions             | Dimensions to set for the alarm.                       | `map(string)`  | `{}`       | no       |
| topic_prefix           | Prefix for the SNS topic names.                        | `string`       | n/a        | yes      |
| statistic              | Statistic to use (default: "Sum").                    | `string`       | "Sum"      | no       |
| alarm_name             | Name of the CloudWatch alarm.                          | `string`       | n/a        | yes      |
| alarm_description      | Description of the CloudWatch alarm.                   | `string`       | ""         | no       |
| namespace              | Namespace of the metric.                              | `string`       | n/a        | yes      |
| metric_name            | Name of the metric.                                   | `string`       | n/a        | yes      |
| threshold              | Threshold for the alarm.                               | `string`       | n/a        | yes      |
| period                 | Period of the metric.                                 | `string`       | n/a        | yes      |
| evaluation_periods     | Number of evaluation periods.                         | `string`       | n/a        | yes      |
| comparison_operator    | Comparison operator for the alarm.                    | `string`       | n/a        | yes      |
| lambda_notification_arn| ARN of the Lambda function for notification.         | `string`       | n/a        | yes      |


## Outputs

| Name            | Description                                       |
|-----------------|---------------------------------------------------|
| alarm_name      | Name of the created CloudWatch alarm.             |
| alarm_arn       | ARN of the created CloudWatch alarm.              |
| alarm_actions   | Actions triggered by the CloudWatch alarm.        |

## TODO
* Make ***lambda_notification_arn*** optional
* Receive a ***list*** of alarms ***instead of 1*** (the idea is to have multiple alarms writing in 1 topic)  

