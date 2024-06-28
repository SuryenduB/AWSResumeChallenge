data "aws_iam_policy_document" "allow_dynamodb_table_operations" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",

      "dynamodb:GetItem",
      "dynamodb:Scan"
    ]

    resources = [
      aws_dynamodb_table.visitors_count.arn,
    ]
  }
}

resource "aws_iam_policy" "dynamodb_lambda_policy" {
  name        = "ResumeChallengeDynamoDBLambdaPolicy"
  description = "Policy for lambda to operate on dynamodb table"
  policy      = data.aws_iam_policy_document.allow_dynamodb_table_operations.json
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.id
  policy_arn = aws_iam_policy.dynamodb_lambda_policy.arn
}


resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.iam_for_lambda.name
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.countVisitors.execution_arn}/*/*/*"
}