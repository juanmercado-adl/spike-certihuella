resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda-invoke-policy"
  role = aws_iam_role.role_for_LDC.id
  policy = file("policy.json")
  # ${aws_dynamodb_table.basic-dynamodb-table.arn}
}


resource "aws_iam_role" "role_for_LDC" {
  name = "lambda-invoke-role"
  assume_role_policy = file("assume_role_policy.json")
}