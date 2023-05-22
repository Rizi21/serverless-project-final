

provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_cognito_user_pool" "example_user_pool" {
  name = "WildRydes"  # Replace with your desired user pool name

  username_attributes = ["email"]

  # Password policy configuration
  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = true
  }

  # Email configuration
/*   email_configuration {
    email_sending_account = "DEVELOPER"
  } */
}

resource "aws_cognito_user_pool_client" "example_user_pool_client" {
  name                   = "WildRydesWebApp"  # Replace with your desired client name
  user_pool_id           = aws_cognito_user_pool.example_user_pool.id
/*   generate_secret        = false
  allowed_oauth_flows    = ["code"]
  allowed_oauth_scopes   = ["openid", "email"]
  allowed_oauth_flows_user_pool_client = true */
}

output "user_pool_id" {
  value = aws_cognito_user_pool.example_user_pool.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.example_user_pool_client.id
}

resource "aws_ses_email_identity" "example" {
  email = "rizwan.farooq@and.digital"
}

resource "aws_ses_domain_mail_from" "example" {
  domain           = aws_ses_email_identity.example.email
  mail_from_domain = "rizwan.farooq@and.digital"
}