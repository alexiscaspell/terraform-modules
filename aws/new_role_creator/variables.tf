variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "role_name" {
  type        = string
  description = "The role name of the role to be created."
}

variable "policies" {
  type        = list(string)
  description = "List of ARNs of existing policies to attach to the user."
  default     = []
}

variable "custom_policies" {
  description = "List of custom policies to create and attach to the user."
  type        = list(map(string))
  default     = []
}

variable "trust_policy" {
  description = "Json path with the role trust policy."
  type        = string
}