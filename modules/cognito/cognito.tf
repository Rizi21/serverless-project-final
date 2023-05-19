resource "aws_cognito_user_pool" "pool" {
  name = "mypool"
}

 # Enabling SMS and Software Token Multi-Factor Authentication
resource "aws_cognito_user_pool" "example" {
  # ... other configuration ...

  mfa_configuration          = "ON"
  sms_authentication_message = "Your code is {####}"

  sms_configuration {
    external_id    = "example"
    sns_caller_arn = aws_iam_role.example.arn
    sns_region     = "us-east-1"
  }

  software_token_mfa_configuration {
    enabled = true
  }
}

# Using Account Recovery Setting
resource "aws_cognito_user_pool" "test" {
  name = "mypool"

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }
}