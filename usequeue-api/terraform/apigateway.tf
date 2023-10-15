#Creating the apigateway for websocket api
resource "aws_apigatewayv2_api" "pasos_api" {
  name                       = "pasos-api"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

#creating the integrations for apigateway
# api routes to backend targets aka the lambda functions with the logic

resource "aws_apigatewayv2_integration" "lambda_connect" {
    api_id            = aws_apigatewayv2_api.pasos_api.id # the id of the api
    integration_type  = "AWS_PROXY" # the type of integration. which means the request will be passed directly to the backend (in this case, a Lambda function), and the response will be relayed back to the client. This is a common setup for Lambda integrations.
    integration_uri   = aws_lambda_function.connect_lambda.invoke_arn # the arn of the lambda function
    integration_method = "POST"
    credentials_arn = aws_iam_role.pasos_api_logging_role.arn
  
}

resource "aws_apigatewayv2_integration" "lambda_disconnect" {
   api_id             = aws_apigatewayv2_api.pasos_api.id
  integration_uri    = aws_lambda_function.disconnect_lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_integration" "lambda_chat_interaction" {
     api_id             = aws_apigatewayv2_api.pasos_api.id
    integration_uri = aws_lambda_function.chat_interaction_lambda.invoke_arn
    integration_type = "AWS_PROXY"
    integration_method = "POST"
}

#creating the routes for apigateway
# routes are the paths that the client will use to connect to the backend targets

# Route for the $connect action
resource "aws_apigatewayv2_route" "connect_route" {
  api_id    = aws_apigatewayv2_api.pasos_api.id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_connect.id}"
}

# Route for the $disconnect action
resource "aws_apigatewayv2_route" "disconnect_route" {
  api_id    = aws_apigatewayv2_api.pasos_api.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_disconnect.id}"
}

# Route for the custom chat_interaction action
resource "aws_apigatewayv2_route" "chat_interaction_route" {
  api_id    = aws_apigatewayv2_api.pasos_api.id
  route_key = "chat_interaction"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_chat_interaction.id}"
}

#creating the deployment for apigateway
#creates a deployment for the api
#this is the initial deployment for the api
resource "aws_apigatewayv2_deployment" "pasos_api_deployment" {
  api_id      = aws_apigatewayv2_api.pasos_api.id
  description = "Initial deployment for pasos-api"

  depends_on = [
    aws_apigatewayv2_route.connect_route,
    aws_apigatewayv2_route.disconnect_route,
    aws_apigatewayv2_route.chat_interaction_route
  ]
}
#creating the stage for apigateway
#creates a production stage for the api
resource "aws_apigatewayv2_stage" "pasos_api_prod_stage" {
  api_id              = aws_apigatewayv2_api.pasos_api.id
  name                = "prod"
  description         = "Production stage for pasos-api"
  auto_deploy         = true

  default_route_settings {
    logging_level = "INFO"
  }
    access_log_settings {
        destination_arn = aws_cloudwatch_log_group.pasos_api_logs.arn
        format = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId"
    }

}

#creating the log group for apigateway
resource "aws_cloudwatch_log_group" "pasos_api_logs" {
  name = "/aws/apigateway/pasos-api"
}





