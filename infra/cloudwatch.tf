resource "aws_cloudwatch_log_group" "log_group" {
 name              = "/aws/lambda/${aws_lambda_function.lambda_process_file.function_name}"
 retention_in_days = 1
}
 
