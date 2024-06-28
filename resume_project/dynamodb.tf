resource "aws_dynamodb_table" "visitors_count" {
  name         = "visitorscount"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  
}