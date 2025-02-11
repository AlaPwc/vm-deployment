resource "aws_api_gateway_rest_api" "example-mcloudshowcase" {
  name        = "ServerlessExample-mcloudshowcase"
  description = "Terraform Serverless Application Example"
}

output "base_url" {
  value = "${aws_api_gateway_deployment.example-mcloudshowcase.invoke_url}"
}
