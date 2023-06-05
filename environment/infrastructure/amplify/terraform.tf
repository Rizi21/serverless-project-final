terraform {
  backend "s3" {
    bucket = "wildrydes123"
    workspace_key_prefix = "wildrydes123-terraform"
    key = "infrastructure/amplify/terraform.state"
    region = "us-east-1"
 }
}
