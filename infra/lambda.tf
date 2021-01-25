resource "aws_lambda_function" "lambda_process_file" {
 function_name = "lambda_process_file"
 role          = "${aws_iam_role.role_lambda_process_file.arn}"
 handler       = "${var.lambda_process_file_handler}"
 filename      = "../projects/lambda-process-file/build/distributions/lambda-process-file-1.15-SNAPSHOT.zip"
 timeout       = 60
 runtime       = "${var.lambda_runtime_2}"
 memory_size   = 1024
}

resource "aws_lambda_permission" "allow_bucket" {
 statement_id  = "AllowExecutionFromS3Bucket"
 action        = "lambda:InvokeFunction"
 function_name = aws_lambda_function.lambda_process_file.arn
 principal     = "s3.amazonaws.com"
 source_arn    = aws_s3_bucket.s3_bucket_certihuella.arn
}


resource "aws_lambda_function" "lambda_client_validation" {
  function_name = "lambda-client-validation"
  s3_bucket     = "${var.s3_bucket}"
  s3_key        = "${var.s3_key}"
  role          = "${aws_iam_role.role_lambda_client_validation.arn}"
  handler       = "${var.lambda_client_validation_handler}"
  runtime       = "${var.lambda_runtime}"
  timeout       = 300
  memory_size   = 2000
}

/*
resource "aws_lambda_permission" "java_lambda_function" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.java_lambda_function.function_name}"
  principal     = "apigateway.amazonaws.com"
  # The /*/#* portion grants access from any method on any resource
  # within the API Gateway "-REST API".
  //source_arn = "${aws_api_gateway_deployment.java_lambda_deploy.execution_arn}/*/*"

