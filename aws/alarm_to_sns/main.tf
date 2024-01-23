
resource "aws_cloudwatch_metric_alarm" "created_alarm" {
  alarm_name          = var.alarm_name
  alarm_description   = var.alarm_description
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  threshold           = var.threshold
  statistic           = var.statistic
  treat_missing_data  = "notBreaching"

  dimensions = var.dimensions

  actions_enabled    = true
  alarm_actions = [aws_sns_topic.alarm_topic.arn]
  ok_actions    = [aws_sns_topic.alarm_topic.arn]
}

resource "aws_sns_topic" "alarm_topic" {
  name = "${var.topic_prefix}AlarmNotificationTopic"
}

resource "aws_sns_topic_subscription" "alarm_topic_target" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  endpoint = var.lambda_notification_arn
  protocol = "lambda"
}

# Allow SNS topic to invoke Lambda function
resource "aws_lambda_permission" "allow_alert_sns" {
  statement_id  = "${var.topic_prefix}AllowSnsAlertToInvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = split(":", var.lambda_notification_arn)[6]
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.alarm_topic.arn
}