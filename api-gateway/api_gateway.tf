resource "aws_api_gateway_rest_api" "main" {
  name = "api-gateway-${var.name}"

  endpoint_configuration {
    types = ["PRIVATE"]
    vpc_endpoint_ids = [var.vpc_endpoint_id]
  }
}

resource "aws_api_gateway_rest_api_policy" "this" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  policy      = data.aws_iam_policy_document.apigateway_access.json
}

data "aws_iam_policy_document" "apigateway_access" {

  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    sid       = "AllowInvokeApigateway"
    actions   = ["execute-api:Invoke"]
    resources = ["${aws_api_gateway_rest_api.main.execution_arn}/*/*/*"]
  }

}

resource "aws_api_gateway_resource" "main" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  parent_id   = "${aws_api_gateway_rest_api.main.root_resource_id}"
  path_part   = var.path_part
}

resource "aws_api_gateway_method" "main" {
  rest_api_id   = "${aws_api_gateway_rest_api.main.id}"
  resource_id   = "${aws_api_gateway_resource.main.id}"
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "main" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_resource.main.id}"
  http_method = "${aws_api_gateway_method.main.http_method}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }

  type                    = var.integration_input_type
  uri                     = "http://${var.nlb_dns_name}:${var.app_port}/{proxy}"
  integration_http_method = var.integration_http_method

  connection_type = "VPC_LINK"
  connection_id   = "${aws_api_gateway_vpc_link.this.id}"
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name = "${var.environment}-env"
  depends_on = [aws_api_gateway_integration.main, aws_api_gateway_rest_api_policy.this]

  variables = {
    # just to trigger redeploy on resource changes
    resources = join(", ", [aws_api_gateway_resource.main.id, aws_api_gateway_rest_api_policy.this.id])

    # note: redeployment might be required with other gateway changes.
    # when necessary run `terraform taint <this resource's address>`
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_domain_name" "this" {
  regional_certificate_arn = var.acm_arn
  domain_name     = "${var.domain_name}"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  
}


resource "aws_api_gateway_base_path_mapping" "this" {
  api_id      = aws_api_gateway_rest_api.main.id
  stage_name  = "${var.environment}-env" 
  #stage_name  = aws_api_gateway_stage.this.stage_name
  domain_name = aws_api_gateway_domain_name.this.domain_name

  depends_on = [ aws_api_gateway_deployment.main ]
}



