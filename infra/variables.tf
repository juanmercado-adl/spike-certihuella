variable "region" {
 default = "us-east-1"
}

# para probar cambiar en los aws
variable "bucket_name" {
 default = "vikingos-process-file-repo2"
}

variable "lambda_runtime" {
    default = "java8"
}

variable "lambda_runtime_2" {
    default = "java11"
}

variable "lambda_client_validation_handler" {
    default = "lambda.java.lab.controller.LambdaController::handleRequest"
}

variable "lambda_process_file_handler" {
    default = "lambda.java.lab.controller.LambdaController::handleRequest"
}

variable "s3_key" {
    default = "lambda-client-validation-1.15-SNAPSHOT.zip"
}

# colocar con el que se haya creado manual
variable "s3_bucket" {
    default = "mybucketjava"
}

variable "dynamodb_table_name"{
    default = "lambda-java-lab"
}

