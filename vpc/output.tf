output vpc_arn {
  value = module.vpc.vpc_arn
}

output vpc_id {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output private_subnet_ids {
  value = module.vpc.private_subnets
}

output public_subnet_ids {
  value = module.vpc.public_subnets
}

output "database_subnet_group_name" {
  value = module.vpc.database_subnet_group_name
}

output ecs_tasks_security_group_id {
  value = aws_security_group.ecs_tasks.id
}

output "vpc_endpoint_ips" {
  value = local.endpoint_primary
}

output "vpc_endpoint_id" {
  value = module.endpoints.endpoints["api_gateway"].id
}