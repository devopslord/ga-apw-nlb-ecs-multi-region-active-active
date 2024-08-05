module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name  = "${var.domain_name}"
  zone_id      = var.zone_id

  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}",
  ]

  wait_for_validation = true

  tags = {
    Name = "${var.domain_name}"
  }
}


resource "aws_lb" "nlb" {
  name               = "nlb-${var.name}"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.private_subnet_ids
  security_groups = [ module.AlbSecurityGroup.security_group_id ]

  enable_deletion_protection = false

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "nlb_tg" {
  depends_on  = [
    aws_lb.nlb
  ]
  name        = "nlb-ecs-${var.environment}-tg"
  port        = var.app_port
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 35
    port                = 8080
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 30
    protocol            = "HTTP"
    matcher             = "200"
      path               = "/health"
  }
}

# Redirect all traffic from the NLB to the target group
resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.id
  port              = var.app_port
  protocol    = "TCP"


  default_action {
    target_group_arn = aws_lb_target_group.nlb_tg.id
    type             = "forward"
  }
}

module "AlbSecurityGroup" {
  source = "terraform-aws-modules/security-group/aws"


  name        = "AlbSecurityGroup"
  description = "Alb Security Group"
  vpc_id      = var.vpc_id

 ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_rules            = ["https-443-tcp", "http-80-tcp"]

  ingress_with_cidr_blocks = [
    {
      protocol = "tcp"
      from_port = 8080
      to_port = 8080
      cidr_blocks = "0.0.0.0/0"
    }
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

