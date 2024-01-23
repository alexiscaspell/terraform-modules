
output "alarm_name" {
  value       = aws_cloudwatch_metric_alarm.created_alarm.alarm_name
  description = "Nombre de la alarma"
}

output "alarm_arn" {
  value       = aws_cloudwatch_metric_alarm.created_alarm.arn
  description = "ARN de la alarma"
}

output "alarm_actions" {
  value       = aws_cloudwatch_metric_alarm.created_alarm.alarm_actions
  description = "Acciones de la alarma"
}