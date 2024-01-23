variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "dimensions" {
  description = "Dimensions to set to the alarm"
  type        = map(string)
}

variable "topic_prefix" {
  description = "Prefix for the topic names to be created"
}

variable "statistic" {
  description = "Statistic to use"
  default     = "Sum"
  type        = string
}

variable "alarm_name" {
  description = "Name of the alarm"
  type        = string
}

variable "alarm_description" {
  description = "Description of the alarm"
  type        = string
}

variable "namespace" {
  description = "Namespace of the metric"
  type        = string
}

variable "metric_name" {
  description = "Name of the metric"
  type        = string
}

variable "threshold" {
  description = "Threshold for the alarm"
  type        = string
}

variable "period" {
  description = "Period of the metric"
  type        = string
}

variable "evaluation_periods" {
  description = "Number of evaluation periods"
  type        = string
}

variable "comparison_operator" {
  description = "Comparison operator"
  type        = string
}

variable "lambda_notification_arn" {
  description = "ARN of the Lambda function for notification"
  type        = string
}