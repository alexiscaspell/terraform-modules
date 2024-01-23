resource "aws_iam_user" "new_user" {
  name = var.user_name
}

resource "aws_iam_user_policy_attachment" "existing_policies" {
  count       = length(var.policies)
  user        = aws_iam_user.new_user.name
  policy_arn  = var.policies[count.index]
}

resource "aws_iam_policy_attachment" "custom_policies" {
  count       = length(var.custom_policies)
  name        = "custom-policy-attachment-${var.user_name}-${count.index}"
  policy_arn  = aws_iam_policy.example[count.index].arn
  users       = [aws_iam_user.new_user.name]
}

resource "aws_iam_access_key" "new_user_access_key" {
  user = aws_iam_user.new_user.name
}

data "template_file" "secret" {
  template =  aws_iam_access_key.new_user_access_key.secret
}