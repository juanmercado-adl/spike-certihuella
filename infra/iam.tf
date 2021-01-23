resource "aws_iam_role_policy" "policy_lambda_client_validation" {
  name = "policy_lambda_client_validation"
  role = aws_iam_role.role_lambda_client_validation.id
  policy = file("policy.json")
  # ${aws_dynamodb_table.basic-dynamodb-table.arn}
}


resource "aws_iam_role" "role_lambda_client_validation" {
  name = "role_lambda_client_validation"
  assume_role_policy = file("assume_role_policy.json")
}

resource "aws_iam_role_policy" "policy_lambda_process_file" {
 name = "policy_lambda_process_file"
 role = aws_iam_role.role_lambda_process_file.id
 
policy = <<-EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": ["s3:ListBucket"],
           "Resource": ["arn:aws:s3:::${var.bucket_name}"]
       },
       {
           "Effect": "Allow",
           "Action": [
               "s3:PutObject",
               "s3:GetObject",
               "s3:DeleteObject"
           ],
           "Resource": ["arn:aws:s3:::${var.bucket_name}/*"]
       }
   ]
}
EOF
}
 
resource "aws_iam_role" "role_lambda_process_file" {
 name = "role_lambda_process_file"
 
 assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_process_file_logs" {
 role       = aws_iam_role.role_lambda_process_file.name
 policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_policy" "lambda_logging" {
 name        = "lambda_logging"
 path        = "/"
 description = "IAM policy for logging from a lambda"
 
 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}