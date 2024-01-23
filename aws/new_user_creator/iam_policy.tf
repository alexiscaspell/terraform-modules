resource "aws_iam_policy" "example" {
  count = length(var.custom_policies)
  name        = var.custom_policies[count.index]["name"]
  description = "Custom policy for user ${var.user_name}"
  policy      = file(var.custom_policies[count.index]["path"])
}