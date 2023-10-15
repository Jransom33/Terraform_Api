# This file contains the terraform code to create the lambda functions
resource "aws_lambda_function" "connect_lambda" {
  function_name    = "WebSocketConnectFunction"
  handler          = "connect.handler" # The entry point in your code
  runtime          = "nodejs14.x"    # Assuming you're using Node.js
  role             = aws_iam_role.lambda_execution_role.arn
  filename         = data.archive_file.connect_lambda_zip.output_path

  source_code_hash = filebase64sha256(data.archive_file.connect_lambda_zip.output_path)

  environment {
    variables = {
        TABLE_NAME = aws_dynamodb_table.connection_table.name
        REGION = "us-east-1"
    }
  }
}

resource "aws_lambda_permission" "connect_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.connect_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_lambda_function" "disconnect_lambda" {
  function_name    = "WebSocketDisconnectFunction"
  handler = "disconnect.handler"
  runtime = "nodejs14.x"
  role = aws_iam_role.lambda_execution_role.arn
  filename         = data.archive_file.disconnect_lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.disconnect_lambda_zip.output_path)

  environment {
    variables = {
        TABLE_NAME = aws_dynamodb_table.connection_table.name
        REGION = "us-east-1"
    }
  }
}
resource "aws_lambda_permission" "disconnect_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.disconnect_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}
  


resource "aws_lambda_function" "chat_interaction_lambda" {
  function_name    = "WebSocketChatInteractionFunction"
  handler = "chat.handler"
  runtime = "nodejs14.x"
  role = aws_iam_role.lambda_execution_role.arn
  filename         = data.archive_file.chat_interaction_lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.chat_interaction_lambda_zip.output_path) 

  environment {
    variables = {
        TABLE_NAME = aws_dynamodb_table.connection_table.name
        REGION = "us-east-1"
    }
  }
}

resource "aws_lambda_permission" "chat_interaction_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.chat_interaction_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}
  

