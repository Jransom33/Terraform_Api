resource "aws_dynamodb_table" "connection_table" {
    name = "connection_table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "connectionId"
    attribute {
        name = "connectionId"
        type = "S"
    }
    tags = {
        Name = "connection_table"
    }
    
}