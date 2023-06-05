output "lambda_function_arn" {
  value = aws_lambda_function.example_lambda.invoke_arn
}

output "lambda_function_name" {
  value = aws_lambda_function.example_lambda.function_name
}