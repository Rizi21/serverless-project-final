output "user_pool_id" {
  value = aws_cognito_user_pool.example_user_pool.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.example_user_pool_client.id
}