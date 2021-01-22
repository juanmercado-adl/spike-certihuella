resource "aws_iam_role_policy" "policy_for_lambda" {
 name = "policy_for_lambda"
 role = aws_iam_role.role_for_lambda.id
 
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
 
resource "aws_iam_role" "role_for_lambda" {
 name = "role_for_lambda"
 
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

resource "aws_lambda_function" "lambda_process_file" {
 function_name = "lambda_process_file"
 role          = aws_iam_role.role_for_lambda.arn
 handler       = "lambda.java.lab.controller.LambdaController::handleRequest"
 filename      = "../projects/lambda-process-file/build/distributions/lambda-process-file-1.15-SNAPSHOT.zip"
 timeout       = 60
 runtime       = "java11"
 memory_size   = 1024
}

resource "aws_lambda_permission" "allow_bucket" {
 statement_id  = "AllowExecutionFromS3Bucket"
 action        = "lambda:InvokeFunction"
 function_name = aws_lambda_function.lambda_process_file.arn
 principal     = "s3.amazonaws.com"
 source_arn    = aws_s3_bucket.s3_bucket_certihuella.arn
}
 
resource "aws_s3_bucket_notification" "bucket_notification" {
 bucket = aws_s3_bucket.s3_bucket_certihuella.id
 
 lambda_function {
   lambda_function_arn = aws_lambda_function.lambda_process_file.arn
   events              = ["s3:ObjectCreated:*"]
   filter_prefix       = "files/"
 }
 depends_on = [aws_lambda_permission.allow_bucket]
}


resource "aws_cloudwatch_log_group" "log_group" {
 name              = "/aws/lambda/${aws_lambda_function.lambda_process_file.function_name}"
 retention_in_days = 1
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
 
 
resource "aws_iam_role_policy_attachment" "lambda_logs" {
 role       = aws_iam_role.role_for_lambda.name
 policy_arn = aws_iam_policy.lambda_logging.arn
}