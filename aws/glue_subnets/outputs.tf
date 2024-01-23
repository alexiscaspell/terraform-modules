output "subnet_availability_ids" {
  description = "List of Glue connection IDs representing subnet availability"
  value       = aws_glue_connection.subnet_availability[*].id
}
