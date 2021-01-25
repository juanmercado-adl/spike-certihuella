data "aws_iam_policy_document" "policy_lambda_client_validation" {
  statement {
    effect = "Allow"
    actions = [
       "dynamodb:BatchGetItem",
       "dynamodb:GetItem",
       "dynamodb:Query",
       "dynamodb:Scan",
       "dynamodb:BatchWriteItem",
       "dynamodb:PutItem",
       "dynamodb:UpdateItem"
    ]
    resources = [
      "${aws_dynamodb_table.basic-dynamodb-table.arn}"
    ]
  }
}

data "aws_iam_policy_document" "assume_role_policy_lambda_client_validation" {
  statement {
    sid = ""
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
        type = "Service"
        identifiers = [
            "lambda.amazonaws.com",
        ]
    }
  }
}

data "aws_iam_policy_document" "policy_dynamodb_lambda_process_file_doc" {
    statement {
        effect = "Allow"
        actions = [
            "dynamodb:BatchGetItem",
            "dynamodb:GetItem",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:BatchWriteItem",
            "dynamodb:PutItem",
            "dynamodb:UpdateItem"
        ]
        resources = [
        "arn:aws:dynamodb:*:*:table/${var.dynamodb_table_name}"
        ]
    }

    statement  {
        sid = "GetStreamRecords"
        effect = "Allow"
        actions = [
            "dynamodb:GetRecords"
        ]
        resources = [
            "arn:aws:dynamodb:*:*:table/SampleTable/stream/* "
        ]
    }

    statement {
        sid = "WriteLogStreamsAndGroups"
        effect = "Allow"
        actions = [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        resources = [
            "*"
        ]
    }

    statement {
        sid = "CreateLogGroup"
        effect = "Allow"
        actions = [
            "logs:CreateLogGroup"
        ]
        resources = [
            "*"
        ]
    }
}

data "aws_iam_policy_document" "policy_s3_lambda_process_file_doc" {
    statement {
        effect = "Allow"
        actions = [
            "s3:ListBucket"
        ]
        resources = [
            "arn:aws:s3:::${var.bucket_name}"
        ]
    }

    statement {
        effect = "Allow"
        actions = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject"
        ]
        resources = [
            "arn:aws:s3:::${var.bucket_name}/*"
        ]
    }
}

data "aws_iam_policy_document" "logging_policy_lambda_process_file" {
    statement{
        effect = "Allow"
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        resources = [
            "arn:aws:logs:*:*:*"
        ]
    }
}

data "aws_iam_policy_document" "assume_role_policy_lambda_process_file" {
  statement {
    sid = ""
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
        type = "Service"
        identifiers = [
            "lambda.amazonaws.com",
        ]
    }
  }
}
