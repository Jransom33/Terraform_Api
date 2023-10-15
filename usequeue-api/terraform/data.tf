data "archive_file" "chat_interaction_lambda_zip" {
  type        = "zip"
  source_file  = "${path.module}/../src/chat_interaction/chat_interaction_lambda.js"
  output_path = "${path.module}/../src/chat_interation/chat_interaction_lambda.zip"
}

data "archive_file" "disconnect_lambda_zip" {
  type        = "zip"
  source_file  = "${path.module}/../src/disconnect/disconnect_lambda.js"
  output_path = "${path.module}/../src/disconnect/disconnect_lambda.zip"
}

data "archive_file" "connect_lambda_zip" {
  type        = "zip"
  source_file  = "${path.module}/../src/connect/connect_lambda.js"
  output_path = "${path.module}/../src/connect/connect_lambda.zip" 
}
