provider "aws" {
  region = "us-east-1"  
}

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

# Lambda Function
resource "aws_lambda_function" "example_lambda" {
  function_name = "RequestUnicorn"
  handler       = "example_lambda.js"
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

