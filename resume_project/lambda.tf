data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_lambda_function" "test_lambda" {
  filename = "index.zip"
  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda.arn
  runtime       = "python3.12"
  handler = "index.lambda_handler"
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  
}

data "aws_iam_policy_document" "lambda_dynamodb" {
  statement {
    effect = "Allow"

    actions = [
      
      "dynamodb:PutItem",
      
      "dynamodb:GetItem",
      "dynamodb:Scan"
    ]

    resources = ["arn:aws:dynamodb:eu-central-1:*:*"]
  }
}

resource "aws_iam_policy" "lambda_dynamodb" {
  name        = "lambda_dynamodb"
  path        = "/"
  description = "IAM policy for managing dynamodb items"
  policy      = data.aws_iam_policy_document.lambda_dynamodb.json
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_dynamodb.arn
}