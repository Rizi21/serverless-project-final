data "aws_secretsmanager_secret_version" "access_token" {
  secret_id = aws_secretsmanager_secret.access_token.id
}