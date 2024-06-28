# resource "aws_apigatewayv2_api" "requestCount" {
#   name          = "requestCount-http-api"
#   protocol_type = "HTTP"
#   cors_configuration {
#     allow_headers = [ "*" ]
#   }
# }

# resource "aws_apigatewayv2_integration" "lambda_integration" {
#   api_id           = aws_apigatewayv2_api.requestCount.id
#   integration_type = "AWS_PROXY"


#   description               = "Lambda example"
#   integration_method        = "POST"
#   integration_uri           = aws_lambda_function.test_lambda.arn

# }

# resource "aws_apigatewayv2_route" "count" {
#   api_id    = aws_apigatewayv2_api.requestCount.id
#   route_key = "POST /count"

#   target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
# }

# resource "aws_apigatewayv2_stage" "prod" {
#   api_id    = aws_apigatewayv2_api.requestCount.id
#   name   = "prod"
# }

