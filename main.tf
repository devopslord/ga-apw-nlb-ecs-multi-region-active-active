provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = var.region2
  alias = "region2"
}

resource "random_pet" "this" {
  length = 2
}

data "aws_caller_identity" "current" {}

# VPC for ECS Fargate
module "vpc_for_ecs_fargate" {
  source = "./vpc"
  vpc_tag_name = "${var.platform_name}-vpc"
  number_of_private_subnets = 2
  private_subnet_tag_name = "${var.platform_name}-private-subnet"
  # route_table_tag_name = "${var.platform_name}-rt"
  environment = var.environment
  security_group_lb_name = "${var.platform_name}-alb-sg"
  security_group_ecs_tasks_name = "${var.platform_name}-ecs-tasks-sg"
  app_port = var.app_port
  # main_pvt_route_table_id = var.main_pvt_route_table_id
  availability_zones = var.availability_zones
  region = var.region
  
}

module "vpc_for_ecs_fargate_secondary" {
  source = "./vpc"
  vpc_tag_name = "${var.platform_name}-vpc"
  number_of_private_subnets = 2
  private_subnet_tag_name = "${var.platform_name}-private-subnet"
  # route_table_tag_name = "${var.platform_name}-rt"
  environment = var.environment
  security_group_lb_name = "${var.platform_name}-alb-sg"
  security_group_ecs_tasks_name = "${var.platform_name}-ecs-tasks-sg"
  app_port = var.app_port
  # main_pvt_route_table_id = var.main_pvt_route_table_id
  availability_zones = var.availability_zones_secondary
  region = var.region2

  providers = {
    aws = aws.region2
  }
}

# ECS cluster
module ecs_cluster {
  source = "./ecs-cluster"
  name = "${var.platform_name}-${var.environment}-cluster"
  cluster_tag_name = "${var.platform_name}-${var.environment}-cluster"
}

module ecs_cluster_secondary {
  source = "./ecs-cluster"
  name = "${var.platform_name}-${var.environment}-cluster"
  cluster_tag_name = "${var.platform_name}-${var.environment}-cluster"

  providers = {
    aws = aws.region2
  }
}

# ECS task definition and service
module ecs_task_definition_and_service {
  # Task definition and NLB
  source = "./ecs-fargate"
  name = "${var.platform_name}-${var.environment}"
  app_image = aws_ecr_repository.this.repository_url
  fargate_cpu                 = 1024
  fargate_memory              = 2048
  app_port = var.app_port
  vpc_id = module.vpc_for_ecs_fargate.vpc_id
  environment = var.environment
  # Service
  cluster_id = module.ecs_cluster.id 
  app_count = var.app_count
  app_count_max = var.app_count_max
  aws_security_group_ecs_tasks_id = module.vpc_for_ecs_fargate.ecs_tasks_security_group_id
  private_subnet_ids = module.vpc_for_ecs_fargate.private_subnet_ids
  region = var.region
  domain_name = var.domain_name
  zone_id = var.zone_id
  secret_arn = aws_secretsmanager_secret.db_pass.arn
}

module ecs_task_definition_and_service_secondary {
  # Task definition and NLB
  source = "./ecs-fargate"
  name = "${var.platform_name}-${var.environment}"
  app_image = aws_ecr_repository.this_sec.repository_url
  fargate_cpu                 = 1024
  fargate_memory              = 2048
  app_port = var.app_port
  vpc_id = module.vpc_for_ecs_fargate_secondary.vpc_id
  environment = var.environment
  # Service
  cluster_id = module.ecs_cluster_secondary.id 
  app_count = var.app_count
  app_count_max = var.app_count_max
  aws_security_group_ecs_tasks_id = module.vpc_for_ecs_fargate_secondary.ecs_tasks_security_group_id
  private_subnet_ids = module.vpc_for_ecs_fargate_secondary.private_subnet_ids
  region = var.region2
  domain_name = var.domain_name
  zone_id = var.zone_id
  secret_arn = aws_secretsmanager_secret.db_pass_sec.arn
  providers = {
    aws = aws.region2
  }
}

# API Gateway and VPC link
module api_gateway {
  source = "./api-gateway"
  name = "${var.platform_name}-${var.environment}"
  integration_input_type = "HTTP_PROXY"
  path_part = "{proxy+}"
  app_port = var.app_port
  nlb_dns_name = module.ecs_task_definition_and_service.nlb_dns_name
  nlb_arn = module.ecs_task_definition_and_service.nlb_arn
  environment = var.environment
  domain_name = var.domain_name
  acm_arn = module.ecs_task_definition_and_service.acm_arn
  vpc_endpoint_id = module.vpc_for_ecs_fargate.vpc_endpoint_id
}

module api_gateway_secondary {
  source = "./api-gateway"
  name = "${var.platform_name}-${var.environment}"
  integration_input_type = "HTTP_PROXY"
  path_part = "{proxy+}"
  app_port = var.app_port
  nlb_dns_name = module.ecs_task_definition_and_service_secondary.nlb_dns_name
  nlb_arn = module.ecs_task_definition_and_service_secondary.nlb_arn
  environment = var.environment
  domain_name = var.domain_name
  acm_arn = module.ecs_task_definition_and_service_secondary.acm_arn
  vpc_endpoint_id = module.vpc_for_ecs_fargate_secondary.vpc_endpoint_id

  providers = {
    aws  = aws.region2
  }
}