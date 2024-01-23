resource "aws_iam_role" "new_role" {
  name = var.role_name

  assume_role_policy = file(var.trust_policy)
}

resource "aws_iam_role_policy_attachment" "existing_policies" {
  count      = length(var.policies)
  role       = aws_iam_role.new_role.name
  policy_arn = var.policies[count.index]
}

resource "aws_iam_policy_attachment" "custom_policies" {
  count       = length(var.custom_policies)
  name        = "custom-policy-attachment-${var.role_name}-${count.index}"
  policy_arn  = aws_iam_policy.example[count.index].arn
  roles       = [aws_iam_role.new_role.name]
}