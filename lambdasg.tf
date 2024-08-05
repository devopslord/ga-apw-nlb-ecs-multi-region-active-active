module "LambdaSecurityGroup" {
  source = "terraform-aws-modules/security-group/aws"


  name        = "LambdaSecurityGroup"
  description = "Lambda Security Group"
  vpc_id      = module.vpc_for_ecs_fargate.vpc_id


  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = [
    {
      protocol = "-1"
      from_port = 0
      to_port = 65535
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

