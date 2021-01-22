variable "region" {
 default = "us-east-1"
}

variable "bucket_name" {
 default = "vikingos-process-file-repo"
}

variable "lambda_runtime" {
    default = "java8"
}

variable "lambda_function_handler" {
    default = "lambda.java.lab.controller.LambdaController::handleRequest"
}

variable "s3_key" {
    default = "lambda-client-validation-1.15-SNAPSHOT.zip"
}

variable "s3_bucket" {
    default = "mybucketjava"
}