resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = var.dynamodb_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "lambda-java-lab-id"
  range_key      = "lambda-name"

  attribute {
    name = "lambda-java-lab-id"
    type = "S"
  }

  attribute {
    name = "lambda-name"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  global_secondary_index {
    name               = "lambda-nameIndex"
    hash_key           = "lambda-java-lab-id"
    range_key          = "lambda-name"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["isbn"]
  }

  tags = {
    Name        = "lambda-java-lab"
    Environment = "production"
  }
}