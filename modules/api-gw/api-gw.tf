provider "aws" {
  region = "us-east-1"  
}

#################################### API-GATEWAY ##########################################################################
# data "aws_cognito_user_pools" "cognito_pool" {
#   name = WildRydes
# }


resource "aws_api_gateway_rest_api" "wildrydes_api" {
  name        = "WildRydes"
  description = "API for WildRydes"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_resource" "rideresource" {
  rest_api_id = aws_api_gateway_rest_api.wildrydes_api.id
  parent_id   = aws_api_gateway_rest_api.wildrydes_api.root_resource_id
  path_part   = "ride"
}  

resource "aws_api_gateway_method" "ride_post_method" {
  rest_api_id = aws_api_gateway_rest_api.wildrydes_api.id
  resource_id = aws_api_gateway_resource.rideresource.id
  http_method = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.wildrydes_authorizer.id
#     request_parameters = {
#     "method.request.path.proxy" = true
#   }
 }



resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.wildrydes_api.id
  resource_id             = aws_api_gateway_resource.rideresource.id
  http_method             = aws_api_gateway_method.ride_post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_function_arn
}


resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.wildrydes_api.id

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_api_gateway_method.ride_post_method, aws_api_gateway_integration.lambda_integration]
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.wildrydes_api.id
  stage_name    = "prod"
}


resource "aws_api_gateway_authorizer" "wildrydes_authorizer" {
  name                            = "WildRydes"
  rest_api_id                     = aws_api_gateway_rest_api.wildrydes_api.id
  type                            = "COGNITO_USER_POOLS"
  provider_arns                   = ["arn:aws:cognito-idp:us-east-1:323040907683:userpool/us-east-1_OkkfcFZg1"]   # or data.aws_cognito_user_pools.this.arns
  identity_source                 = "method.request.header.Authorization"
}


resource "aws_api_gateway_method_response" "cors" {
  rest_api_id = aws_api_gateway_rest_api.wildrydes_api.id
  resource_id = aws_api_gateway_resource.rideresource.id
  http_method = aws_api_gateway_method.ride_post_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options" {
  rest_api_id = aws_api_gateway_rest_api.wildrydes_api.id
  resource_id = aws_api_gateway_resource.rideresource.id
  http_method = aws_api_gateway_integration.lambda_integration.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:us-east-1:323040907683:${aws_api_gateway_rest_api.wildrydes_api.id}/*/${aws_api_gateway_method.ride_post_method.http_method}${aws_api_gateway_resource.rideresource.path}"
}


module "cors" {
  source = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"
  api_id            = aws_api_gateway_rest_api.wildrydes_api.id
  api_resource_id   = aws_api_gateway_resource.rideresource.id
}



# resource "aws_api_gateway_method_settings" "ride_method_settings" {
#   rest_api_id = aws_api_gateway_rest_api.wildrydes_api.id
#   stage_name  = "prod"
#   method_path = aws_api_gateway_resource.rideresource.path_part
 
# #   settings {
# #     authorization_type = "COGNITO_USER_POOLS"
# #     authorizer_id      = aws_api_gateway_authorizer.wildrydes_authorizer.id
# #   }
# }

# resource "aws_api_gateway_method_response" "method_response" {
#   rest_api_id = aws_api_gateway_rest_api.wildrydes_api.id
#   resource_id = aws_api_gateway_resource.rideresource.id
#   http_method = aws_api_gateway_method.ride_post_method.http_method
#   status_code = "200"
#    response_models = {
#     "application/json" = "Empty"
#   }
# }

# resource "aws_api_gateway_gateway_response" "cors" {
#   rest_api_id = aws_api_gateway_rest_api.wildrydes_api.id
#   response_type = "DEFAULT_4XX"

#   response_parameters = {
#     "gatewayresponse.header.Access-Control-Allow-Origin" = "'*'"
#     "gatewayresponse.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
#     "gatewayresponse.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
#   }
# }

