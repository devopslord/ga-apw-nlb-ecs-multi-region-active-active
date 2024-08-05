# # ECR
# resource "aws_vpc_endpoint" "ecr_dkr" {
#   vpc_id       = "${module.vpc.vpc_id}"
#   service_name = "com.amazonaws.${var.region}.ecr.dkr"
#   vpc_endpoint_type = "Interface"
#   private_dns_enabled = true
#   subnet_ids          = module.vpc.private_subnets

#   security_group_ids = [
#     aws_security_group.ecs_tasks.id,
#   ]

#   tags = {
#     Name = "ECR Docker VPC Endpoint Interface - ${var.environment}"
#     Environment = var.environment
#   }
# }

# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id       = "${module.vpc.vpc_id}"
#   service_name = "com.amazonaws.${var.region}.ecr.api"
#   vpc_endpoint_type = "Interface"
#   private_dns_enabled = true
#   subnet_ids          = module.vpc.private_subnets

#   security_group_ids = [
#     aws_security_group.ecs_tasks.id,
#   ]

#   tags = {
#     Name = "ECR API VPC Endpoint Interface - ${var.environment}"
#     Environment = var.environment
#   }
# }

# # CloudWatch
# resource "aws_vpc_endpoint" "cloudwatch" {
#   vpc_id       = "${module.vpc.vpc_id}"
#   service_name = "com.amazonaws.${var.region}.logs"
#   vpc_endpoint_type = "Interface"
#   subnet_ids          = module.vpc.private_subnets
#   private_dns_enabled = true

#   security_group_ids = [
#     aws_security_group.ecs_tasks.id,
#   ]

#   tags = {
#     Name = "CloudWatch VPC Endpoint Interface - ${var.environment}"
#     Environment = var.environment
#   }
# }

# #

# # S3
# resource "aws_vpc_endpoint" "s3" {
#   vpc_id       = "${module.vpc.vpc_id}"
#   service_name = "com.amazonaws.${var.region}.s3"
#   vpc_endpoint_type = "Gateway"
#   route_table_ids = [module.vpc.default_route_table_id]

#   tags = {
#     Name = "S3 VPC Endpoint Gateway - ${var.environment}"
#     Environment = var.environment
#   }
# }

module "endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  vpc_id             = module.vpc.vpc_id

  endpoints = {
    api_gateway = {
      # interface endpoint
      service             = "execute-api"
      subnet_ids         = module.vpc.private_subnets 
      tags                = { Name = "execute-api" }
    }
  }

}

data "dns_a_record_set" "primary" {
  host = module.endpoints.endpoints["api_gateway"].dns_entry[0].dns_name
}


locals {
  endpoint_primary = tolist(data.dns_a_record_set.primary.addrs)
}