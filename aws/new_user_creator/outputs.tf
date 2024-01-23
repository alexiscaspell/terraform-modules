output "user_arn" {
  value = aws_iam_user.new_user.arn
}

output "access_key_details" {
  value = <<EOF
    user               = ${aws_iam_access_key.new_user_access_key.user}
    access_key_id      = ${aws_iam_access_key.new_user_access_key.id}
    access_key_secret  = ${data.template_file.secret.rendered}
    status             = ${aws_iam_access_key.new_user_access_key.status}
    create_date        = ${aws_iam_access_key.new_user_access_key.create_date}
EOF
}