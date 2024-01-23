output "lambda_arn" {
  value       = aws_lambda_function.cloudwatch_teams_notifier.arn
  description = "Lambda ARN"
}

output "lambda_name" {
  value       = aws_lambda_function.cloudwatch_teams_notifier.function_name
  description = "Lambda name"
}
