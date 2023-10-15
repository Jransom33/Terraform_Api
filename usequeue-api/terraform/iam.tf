resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Add any required permissions policies and attach them to the role if necessary


# Policy for pasos api gateway logging
resource "aws_iam_role" "pasos_api_logging_role" {
  name = "PasosApiGatewayLoggingRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "apigateway.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "pasos_api_logging_policy" {
  name        = "PasosApiGatewayLoggingPolicy"
  description = "Allows API Gateway to write logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Effect   = "Allow",
      Resource = "arn:aws:logs:*:*:*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "pasos_api_logging_attach" {
  role       = aws_iam_role.pasos_api_logging_role.name
  policy_arn = aws_iam_policy.pasos_api_logging_policy.arn
}

resource "aws_iam_policy" "api_gateway_create_api" {
  name        = "APIGatewayCreateAPIPolicy"
  description = "Allows creating an API in API Gateway"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "apigateway:POST",
        Resource = "arn:aws:apigateway:us-east-1::/apis"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_api_gateway_create_policy" {
  policy_arn = aws_iam_policy.api_gateway_create_api.arn
  role       = aws_iam_role.pasos_api_logging_role.name
}

resource "aws_iam_policy" "cloudwatch_describe_log_groups" {
  name        = "CloudWatchDescribeLogGroups"
  description = "Grants permission to describe CloudWatch log groups"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "logs:DescribeLogGroups",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_describe" {
  policy_arn = aws_iam_policy.cloudwatch_describe_log_groups.arn
  role       = "github-oidc-connect"  # replace with the ARN if you're not creating this role in the same Terraform script
}







