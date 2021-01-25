resource "aws_iam_role_policy" "policy_lambda_client_validation" {
  name = "policy_lambda_client_validation"
  role = aws_iam_role.role_lambda_client_validation.id
  policy = data.aws_iam_policy_document.policy_lambda_client_validation.json
}


resource "aws_iam_role" "role_lambda_client_validation" {
  name = "role_lambda_client_validation"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_lambda_client_validation.json
}

resource "aws_iam_role_policy" "policy_dynamodb_lambda_process_file" {
 name = "policy_dynamodb_lambda_process_file"
 role = aws_iam_role.role_lambda_process_file.id
 policy = data.aws_iam_policy_document.policy_dynamodb_lambda_process_file_doc.json
}

resource "aws_iam_role_policy" "policy_s3_lambda_process_file" {
 name = "policy_s3_lambda_process_file"
 role = aws_iam_role.role_lambda_process_file.id
 policy = data.aws_iam_policy_document.policy_s3_lambda_process_file_doc.json
}
 
resource "aws_iam_role" "role_lambda_process_file" {
 name = "role_lambda_process_file"
 assume_role_policy = data.aws_iam_policy_document.assume_role_policy_lambda_process_file.json
}

resource "aws_iam_role_policy_attachment" "lambda_process_file_logs" {
 role       = aws_iam_role.role_lambda_process_file.name
 policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_policy" "lambda_logging" {
 name        = "lambda_logging"
 path        = "/"
 description = "IAM policy for logging from a lambda"
 policy = data.aws_iam_policy_document.logging_policy_lambda_process_file.json
}