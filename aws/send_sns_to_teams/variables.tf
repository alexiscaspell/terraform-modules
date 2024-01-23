variable "lambda_function_name" {
  type        = string
  description = "Lambda function name."
}

variable "lambda_timeout" {
  type        = string
  description = "Lambda function timeout in seconds. Default: '15'"
  default     = "15"
}

variable "retention_in_days" {
  type        = string
  description = "Lambda function logs retention in days. Default: '1'"
  default     = "1"
}

variable "teams_webhook" {
  type        = string
  description = "Teams webhook"
}

variable "lambda_python_runtime" {
  description = "Defines the version of the runtime for the Lambdas that use python."
  type        = string
}
