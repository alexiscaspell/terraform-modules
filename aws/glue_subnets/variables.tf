variable "subnet_ids" {
  description = "List of subnet IDs to make available for later use"
  type        = list(string)
}

variable "eks_worker_sg" {
  description = "ID of the eks worker sg"
  type        = string
}

variable "glue_connection_prefix" {
  description = "Prefix of the connection names to create"
  type        = string
  default     = "subnet-availability-"
}