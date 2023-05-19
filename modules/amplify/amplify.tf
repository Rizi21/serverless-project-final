provider "aws" {
  region = "us-east-1"  
}

resource "aws_amplify_app" "example" {
  name       = "wild-rydes-app"  
  repository = "https://github.com/Rizi21/serverless-project-final"  # Add the Git repository URL

    access_token = "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"
}

resource "aws_amplify_branch" "master" {
  app_id    = aws_amplify_app.example.id
  branch_name = "main"  
  enable_pull_request_preview = true
  enable_auto_build = true
}


/* resource "aws_amplify_domain" "example" {
  domain_name = "example.com"  # Replace with your desired domain name
  sub_domain  = "www"  # Replace with your desired subdomain

  app_id = aws_amplify_app.example.app_id 
} */

