resource "aws_amplify_app" "example" {
  name       = "wild-rydes-app"
  repository = "https://github.com/Rizi21/serverless-project-final"  # Add the Git repository URL
    access_token = data.aws_secretsmanager_secret_version.access_token.secret_string
  # custom_rule {
  #   source = "${var.build_settings_file}"
  #   target = "amplifyconfiguration.js"
  # }
  #     custom_rule {
  #   source = "/wild-ryde-app/html/(.*)"
  #   target = "/$1"
  # }
}
resource "aws_amplify_branch" "master" {
  app_id    = aws_amplify_app.example.id
  branch_name = "main"
  enable_pull_request_preview = true
  enable_auto_build = true
}
