resource "aws_api_gateway_rest_api" "wildrydes_api" {
  name        = "WildRydes"
  description = "API for WildRydes"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_resource" "rideresource" {
  rest_api_id = aws_api_gateway_rest_api.WildRydes.id
  parent_id   = aws_api_gateway_rest_api.WildRydes.root_resource_id
  path_part   = "rideresource"
}

resource "aws_api_gateway_method" "ride_post_method" {
  rest_api_id = aws_api_gateway_rest_api.wildrydes_api.id
  resource_id = aws_api_gateway_resource.ride_resource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_settings" "ride_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.wildrydes_api.id
  stage_name  = "prod"
  method_path = aws_api_gateway_resource.ride_resource.path_part

  settings {
    authorization_type = "COGNITO_USER_POOLS"
    authorizer_id      = aws_api_gateway_authorizer.wildrydes_authorizer.id
  }
}

resource "aws_api_gateway_deployment" "wildrydes_deployment" {
  depends_on    = [aws_api_gateway_method_settings.ride_method_settings]
  rest_api_id   = aws_api_gateway_rest_api.wildrydes_api.id
  stage_name    = "prod"
  description   = "Production Deployment"
  variables     = {
    "environment" = "production"
  }
}