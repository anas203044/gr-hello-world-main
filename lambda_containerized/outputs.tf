

output "lambda_arn" {
  value = aws_lambda_function.this.arn
}

output "lambda_name" {
  value = aws_lambda_function.this.function_name
}


output "role_arn" {
  value = module.role.role_arn
}

output "security_group_id" {
  value = try(aws_security_group.this[0].id, null)
}


output "lambda" {
  value = aws_lambda_function.this.arn
}

output "aws_security_group" {
  value = aws_security_group.this
}
