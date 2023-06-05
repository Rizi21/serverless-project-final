module "api-gw" {
    source = "../../../modules/api-gw"

    lambda_function_name = data.terraform_remote_state.lambda.outputs.lambda_function_name
    lambda_function_arn  = data.terraform_remote_state.lambda.outputs.lambda_function_arn



}

