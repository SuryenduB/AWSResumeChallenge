# resource "aws_api_gateway_rest_api" "visitors_count" {
#   name        = "visitors-count"
#   description = "Visitors Count API Gateway"

#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
# }

# resource "aws_api_gateway_resource" "root" {
#   rest_api_id = aws_api_gateway_rest_api.visitors_count.id
#   parent_id   = aws_api_gateway_rest_api.visitors_count.root_resource_id
#   path_part   = "visitors_count"
# }



# resource "aws_api_gateway_integration" "lambda_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.visitors_count.id
#   resource_id             = aws_api_gateway_resource.root.id
#   http_method = "POST"
#   integration_http_method = "POST"
#   type                    = "AWS"
#   uri                     = aws_lambda_function.test_lambda.invoke_arn
# }





# resource "aws_api_gateway_deployment" "deployment" {
#   depends_on = [
#     aws_api_gateway_integration.lambda_integration,

#   ]

#   rest_api_id = aws_api_gateway_rest_api.visitors_count.id
#   stage_name  = "prod"
# }


# resource "aws_iam_role_policy_attachment" "lambda_basic" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#   role       = aws_iam_role.iam_for_lambda.name
# }

# resource "aws_lambda_permission" "apigw_lambda" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.test_lambda.function_name
#   principal     = "apigateway.amazonaws.com"

#   source_arn = "${aws_api_gateway_rest_api.visitors_count.execution_arn}/*/*/*"
# }

# resource "aws_api_gateway_method_response" "proxy" {
#   rest_api_id = aws_api_gateway_rest_api.visitors_count.id
#   resource_id = aws_api_gateway_resource.root.id
#   http_method = aws_api_gateway_method.proxy.http_method
#   status_code = "200"

#   //cors section
#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true,
#     "method.response.header.Access-Control-Allow-Methods" = true,
#     "method.response.header.Access-Control-Allow-Origin"  = true
#   }

# }

# resource "aws_api_gateway_integration_response" "proxy" {
#   rest_api_id = aws_api_gateway_rest_api.visitors_count.id
#   resource_id = aws_api_gateway_resource.root.id
#   http_method = aws_api_gateway_method.proxy.http_method
#   status_code = aws_api_gateway_method_response.proxy.status_code


#   //cors
#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
#     "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#   }

#   depends_on = [
#     aws_api_gateway_method.proxy,
#     aws_api_gateway_integration.lambda_integration
#   ]
# }
