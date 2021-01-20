resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "dynamodb-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "isbn"
  range_key      = "name"

  attribute {
    name = "isbn"
    type = "S"
  }

  attribute {
    name = "name"
    type = "S"
  }

  attribute {
    name = "description"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  global_secondary_index {
    name               = "nameIndex"
    hash_key           = "name"
    range_key          = "description"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["isbn"]
  }

  tags = {
    Name        = "dynamodb-table"
    Environment = "production"
  }
}