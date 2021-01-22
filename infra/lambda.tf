resource "aws_lambda_function" "lambda_client_validation" {

  function_name = "lambda-client-validation"
  s3_bucket     = "${var.s3_bucket}"
  s3_key        = "${var.s3_key}"
  role          = "${aws_iam_role.role_for_LDC.arn}"
  handler       = "${var.lambda_function_handler}"
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
  # within the API Gateway "REST API".
  //source_arn = "${aws_api_gateway_deployment.java_lambda_deploy.execution_arn}/*/*"
