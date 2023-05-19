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
      "Resource": "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${var.dynamodb_table_name}"
    }
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
  handler       = "index.handler"
  runtime       = "nodejs16.x"
  timeout       = 10

  # IAM role for the Lambda function
  role          = aws_iam_role.lambda_execution_role.arn

  # The Lambda function code
  filename      = "index.js"
  source_code_hash = filebase64sha256("index.js")

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.rides_table.name
    }
  }
}