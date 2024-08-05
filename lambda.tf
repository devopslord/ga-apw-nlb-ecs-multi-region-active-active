resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "lambda-func/python-layer.zip"
  layer_name = "t360-layer"

  compatible_runtimes = ["python3.11", "python3.9", "python3.10", "python3.8"]
}


module "Create_Table" {
  source = "terraform-aws-modules/lambda/aws"
  layers = [ aws_lambda_layer_version.lambda_layer.arn, "arn:aws:lambda:${var.region}:580247275435:layer:LambdaInsightsExtension:21" ]


  function_name = "Create_Api_Table"
  handler       = "api.revenue_codes"
  runtime       = "python3.8"
  architectures = ["x86_64"]
  create_lambda_function_url = true
  timeout       = 900
  tracing_mode  = "Active"
  publish       = true
  store_on_s3   = false
  memory_size   = 1024


  source_path = "${path.module}/lambda-func/src/"

  vpc_subnet_ids = module.vpc_for_ecs_fargate.private_subnet_ids
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

  environment_variables = {
    SECRET_NAME = "${var.platform_name}-${random_pet.this.id}"
    REGION      = var.region
  }

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     secrets_manager = {
      effect = "Allow"
      actions = [
        "secretsmanager:GetSecretValue"
      ]
      resources = ["*"]
     }
   }
}