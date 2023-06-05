data "terraform_remote_state" "lambda" {
  backend = "s3"
  config = {
    bucket    = "wildrydes123"
    key       = "wildrydes123-terraform/${terraform.workspace}/infrastructure/lambda/terraform.state"
    region    = "us-east-1"
  }
}
