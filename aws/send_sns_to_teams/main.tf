locals {
  lambda_path = "sns_to_teams.py"
}

resource "aws_iam_role" "iam_for_lambda" {
  name_prefix        = "cloudwatch_teams_notifier_lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = var.retention_in_days
}

resource "aws_iam_policy" "lambda" {
  path        = "/"
  name_prefix = "${var.lambda_function_name}-policy"
  description = "IAM policy for logging from a lambda and CloudWatch metric PUT"
  policy      = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda.arn

  depends_on = [aws_iam_policy.lambda]
}

data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/${local.lambda_path}"
  output_path = "${path.module}/${local.lambda_path}.zip"
}

resource "aws_lambda_function" "cloudwatch_teams_notifier" {
  filename      = "${path.module}/${local.lambda_path}.zip"
  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "sns_to_teams.lambda_handler"
  timeout       = var.lambda_timeout

  source_code_hash = data.archive_file.init.output_base64sha256

  runtime = var.lambda_python_runtime

  environment {
    variables = {
      TEAMS_WEBHOOK = var.teams_webhook
    }
  }
}
