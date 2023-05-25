provider "aws" {
  region = "us-east-1"  
}
################################ Lambda Function & IAM ROLES  ##########################################################################
resource "aws_iam_role" "wild_rydes_lambda_role" {
  name               = "WildRydesLambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "s3_read_unzip_policy" {
  name        = "S3ReadUnzipPolicy"
  description = "Allows Lambda function to read and unzip files from S3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowS3Read",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::wildrydes123/*"
    },
    {
      "Sid": "AllowUnzip",
      "Effect": "Allow",
      "Action": [
        "lambda:CreateEventSourceMapping",
        "lambda:ListEventSourceMappings"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3_read_unzip_attachment" {
  role       = aws_iam_role.wild_rydes_lambda_role.name
  policy_arn = aws_iam_policy.s3_read_unzip_policy.arn
}

resource "aws_iam_policy" "wild_rydes_lambda_cloudwatch_logs_policy" {
  name        = "WildRydesLambdaCloudWatchLogsPolicy"
  description = "Policy for WildRydesLambda to write logs to CloudWatch Logs"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CloudWatchLogsWriteAccess",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "wild_rydes_lambda_dynamodb_policy" {
  name        = "WildRydesLambdaDynamoDBPolicy"
  description = "Policy for WildRydesLambda to put items in DynamoDB"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DynamoDBWriteAccess",
      "Effect": "Allow",
      "Action": "dynamodb:PutItem",
      "Resource": "arn:aws:dynamodb:us-east-1:323040907683:table/Rides"     }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "wild_rydes_lambda_cloudwatch_logs_attachment" {
  role       = aws_iam_role.wild_rydes_lambda_role.name
  policy_arn = aws_iam_policy.wild_rydes_lambda_cloudwatch_logs_policy.arn
}

resource "aws_iam_role_policy_attachment" "wild_rydes_lambda_dynamodb_attachment" {
  role       = aws_iam_role.wild_rydes_lambda_role.name
  policy_arn = aws_iam_policy.wild_rydes_lambda_dynamodb_policy.arn
}





resource "aws_lambda_function" "example_lambda" {
  function_name = "RequestUnicorn"
  handler       = "index.handler"
  runtime       = "nodejs16.x"
  timeout       = 10

  s3_bucket       = "wildrydes123"  # Replace with the name of your S3 bucket
  s3_key          = "requestUnicorn.js.zip"  # Replace with the path to your .js file in the S3 bucket



  # IAM role for the Lambda function
  role          = aws_iam_role.wild_rydes_lambda_role.arn

  # The Lambda function code
/*   filename      = "index.js"
  source_code_hash = filebase64sha256("index.js")

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.rides_table.name
    }
  } */
}
###############################################################################################################

##################################### API-GATEWAY ##########################################################################

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
}  # should path part be just ride? yes

resource "aws_api_gateway_method" "ride_post_method" {
  rest_api_id = aws_api_gateway_rest_api.wildrydes_api.id
  resource_id = aws_api_gateway_resource.rideresource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.wildrydes_api.id
  resource_id             = aws_api_gateway_resource.rideresource.id
  http_method             = aws_api_gateway_method.ride_post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.example_lambda.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:us-east-1:323040907683:${aws_api_gateway_rest_api.wildrydes_api.id}/*/${aws_api_gateway_method.ride_post_method.http_method}${aws_api_gateway_resource.rideresource.path}"
}

# resource "aws_api_gateway_method_settings" "ride_method_settings" {
#   rest_api_id = aws_api_gateway_rest_api.wildrydes_api.id
#   stage_name  = "prod"
#   method_path = aws_api_gateway_resource.ride_resource.path_part

#   settings {
#     authorization_type = "COGNITO_USER_POOLS"
#     authorizer_id      = aws_api_gateway_authorizer.wildrydes_authorizer.id
#   }
# }

# # resource "aws_api_gateway_deployment" "wildrydes_deployment" {
# #   depends_on    = [aws_api_gateway_method_settings.ride_method_settings]
# #   rest_api_id   = aws_api_gateway_rest_api.wildrydes_api.id
# #   stage_name    = "prod"
# #   description   = "Production Deployment"
# #   variables     = {
# #     "environment" = "production"
# #   }
# # }
