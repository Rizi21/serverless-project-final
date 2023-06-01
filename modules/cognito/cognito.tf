

provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_cognito_user_pool" "cognito_user_pool" {
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

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                   = "WildRydesWebApp"  # Replace with your desired client name
  user_pool_id           = var.cognito_user_pool
/*   generate_secret        = false
  allowed_oauth_flows    = ["code"]
  allowed_oauth_scopes   = ["openid", "email"]
  allowed_oauth_flows_user_pool_client = true */
}

resource "aws_ses_email_identity" "email_identity" {
  email = "rizwan.farooq@andigital.com"
}

resource "aws_ses_domain_mail_from" "domain_mail_from" {
  domain           = aws_ses_email_identity.email_identity.email
  mail_from_domain = "bounce.${aws_ses_domain_identity.domain_identity.domain}"
}

resource "aws_ses_domain_identity" "domain_identity" {
  domain = "andigital.com"
}