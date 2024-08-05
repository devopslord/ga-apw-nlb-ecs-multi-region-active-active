# resource "aws_vpc" "custom_vpc" {
#   cidr_block       = var.vpc_cidr_block
#   enable_dns_support = true
#   enable_dns_hostnames = true

#   tags = {
#     Name = "${var.vpc_tag_name}-${var.environment}"
#   }
# }

### VPC Network Setup

# Create the private subnets
# resource "aws_subnet" "private_subnet" {
#   count = var.number_of_private_subnets
#   vpc_id            = "${aws_vpc.custom_vpc.id}"
#   cidr_block = "${element(var.private_subnet_cidr_blocks, count.index)}"
#   availability_zone = "${element(var.availability_zones, count.index)}"

#   tags = {
#     Name = "${var.private_subnet_tag_name}-${var.environment}"
#   }
# }

### Security Group Setup

# ALB Security group (If you want to use ALB instead of NLB. NLB doesn't use Security Groups)
resource "aws_security_group" "lb" {
  name        = "${var.security_group_lb_name}-${var.environment}"
  description = var.security_group_lb_description
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Traffic to the ECS Cluster should only come from the ALB
# or AWS services through an AWS PrivateLink
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.security_group_ecs_tasks_name}-${var.environment}"
  description = var.security_group_ecs_tasks_description
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    cidr_blocks = [var.vpc_cidr_block]
  }


  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name = "${var.vpc_tag_name}-${var.environment}"
  cidr = var.vpc_cidr_block

  azs              = var.availability_zones
  public_subnets   = var.private_subnet_cidr_blocks_public
  private_subnets  = var.private_subnet_cidr_blocks
  database_subnets = var.database_subnet_cidr_blocks
  single_nat_gateway = true
  enable_nat_gateway = true

  default_security_group_ingress = [ 
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "http-443-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  default_security_group_egress = [
    {
      protocol = "-1"
      from_port = 0
      to_port = 0
      cidr_blocks = "0.0.0.0/0"
    }
  ]


  tags = {
    Name = "${var.vpc_tag_name}-${var.environment}"
  }
}