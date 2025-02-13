provider "aws" {
  region = "eu-central-1"
}

# terraform import aws_iam_role.lambda_exec lambda_exec

resource "aws_lambda_function" "example-mcloudshowcase" {
  function_name = "ServerlessExample-mcloudshowcase"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = "mcloud-showcase-jean-s3"
  s3_key    = "AKIAS6KS4GQ2J3NACOV4"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "main.handler"
  runtime = "nodejs12.x"

  role = "${aws_iam_role.lambda_exec_mcloud_showcase.arn}"
}

# IAM role which dictates what other AWS services the Lambda function
# may access.

resource "aws_iam_role" "lambda_exec_mcloud_showcase" {
 # name = "lambda-mcloudshowcase"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.example-mcloudshowcase.id}"
  parent_id   = "${aws_api_gateway_rest_api.example-mcloudshowcase.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.example-mcloudshowcase.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.example-mcloudshowcase.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.example-mcloudshowcase.invoke_arn}"
}


resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.example-mcloudshowcase.id}"
  resource_id   = "${aws_api_gateway_rest_api.example-mcloudshowcase.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.example-mcloudshowcase.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.example-mcloudshowcase.invoke_arn}"
}


resource "aws_api_gateway_deployment" "example-mcloudshowcase" {
  depends_on = [
    "aws_api_gateway_integration.lambda",
    "aws_api_gateway_integration.lambda_root",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.example-mcloudshowcase.id}"
  stage_name  = "test"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.example-mcloudshowcase.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.example-mcloudshowcase.execution_arn}/*/*"
}

