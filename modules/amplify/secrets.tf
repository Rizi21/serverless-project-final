provider "aws" {
  region = "us-east-1"
}


resource "aws_secretsmanager_secret" "access_token" {
  name = "riz-access-token"
}

resource "aws_secretsmanager_secret_version" "access_token" {
  secret_id     = aws_secretsmanager_secret.access_token.id
  secret_string = var.access_token
}