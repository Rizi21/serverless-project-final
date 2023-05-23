provider "aws" {
  region = "us-east-1"  
}

resource "aws_amplify_app" "example" {
  name       = "wild-rydes-app"  
  repository = "https://github.com/Rizi21/serverless-project-final"  # Add the Git repository URL
  

    access_token = "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"

    # The default build_spec added by the Amplify Console for React.
  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - yarn install
        build:
          commands:
            - yarn run
      artifacts:
        baseDirectory: .
        files:
          - '/wild-ryde-app'
      cache:
        paths:
          - node_modules/**/*
  EOT

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  environment_variables = {
    ENV = "dev"
  }
}


resource "aws_amplify_branch" "master" {
  app_id     = aws_amplify_app.example.id
  branch_name = "main"  # Replace with your desired branch name
  enable_auto_build = true
  enable_pull_request_preview = true

}



/* resource "aws_amplify_domain" "example" {
  domain_name = "example.com"  # Replace with your desired domain name
  sub_domain  = "www"  # Replace with your desired subdomain

  app_id = aws_amplify_app.example.app_id 
} */

/* resource "aws_amplify_branch" "master" {
  app_id    = aws_amplify_app.example.id
  branch_name = "main"  
  enable_pull_request_preview = true
  enable_auto_build = true */