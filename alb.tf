module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "t360-lb"
  vpc_id  = module.vpc_for_ecs_fargate.vpc_id
  subnets = module.vpc_for_ecs_fargate.public_subnet_ids

  enable_deletion_protection = false



  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  listeners = {
    ex-http-https-redirect = {
      port     = 443
      protocol = "HTTPS"
      certificate_arn             = module.ecs_task_definition_and_service.acm_arn
      forward = {
        target_group_key = "ex-ip"
      }
    }
    ex-http-https = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  target_groups = {
    ex-ip = {
      name_prefix               = "l1-"
      target_type               = "ip"
      protocol                  = "HTTPS"
      port                      = 443
      target_id                 = module.vpc_for_ecs_fargate.vpc_endpoint_ips[0]
      health_check = {
        enabled             = true
        interval            = 35
        port                = 443
        healthy_threshold   = 3
        unhealthy_threshold = 5
        timeout             = 30
        protocol            = "HTTPS"
        matcher             = "403"
      }
    }
  }

  additional_target_group_attachments = {
    ip1 = {
      target_group_key = "ex-ip"
      target_id        =  module.vpc_for_ecs_fargate.vpc_endpoint_ips[1]
      port             = 443
    }

    ip2 = {
      target_group_key = "ex-ip"
      target_id        =  module.vpc_for_ecs_fargate.vpc_endpoint_ips[2]
      port             = 443
    }

  }

}

module "alb_secondary" {
  source = "terraform-aws-modules/alb/aws"
  providers = {
    aws = aws.region2
  }

  name    = "t360-lb"
  vpc_id  = module.vpc_for_ecs_fargate_secondary.vpc_id
  subnets = module.vpc_for_ecs_fargate_secondary.public_subnet_ids

  enable_deletion_protection = false



  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  listeners = {
    ex-http-https-redirect = {
      port     = 443
      protocol = "HTTPS"
      certificate_arn             = module.ecs_task_definition_and_service_secondary.acm_arn
      forward = {
        target_group_key = "ex-ip"
      }
    }
    ex-http-https = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  target_groups = {
    ex-ip = {
      name_prefix               = "l1-"
      target_type               = "ip"
      protocol                  = "HTTPS"
      port                      = 443
      target_id                 = module.vpc_for_ecs_fargate_secondary.vpc_endpoint_ips[0]
      health_check = {
        enabled             = true
        interval            = 35
        port                = 443
        healthy_threshold   = 3
        unhealthy_threshold = 5
        timeout             = 30
        protocol            = "HTTPS"
        matcher             = "403"
      }
    }
  }

  additional_target_group_attachments = {
    ip1 = {
      target_group_key = "ex-ip"
      target_id        =  module.vpc_for_ecs_fargate_secondary.vpc_endpoint_ips[1]
      port             = 443
    }

    ip2 = {
      target_group_key = "ex-ip"
      target_id        =  module.vpc_for_ecs_fargate_secondary.vpc_endpoint_ips[2]
      port             = 443
    }

  }

}


module "alb_load" {
  source = "terraform-aws-modules/alb/aws"

  name    = "${var.platform_name}-Locust"
  vpc_id  = module.vpc_for_ecs_fargate.vpc_id
  subnets = module.vpc_for_ecs_fargate.public_subnet_ids

  enable_deletion_protection = false



  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  listeners = {
    ex-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
      # forward = {
      #   target_group_key = "ex-ip"
      # }
    }
      
    ex-https = {
      port     = 443
      protocol = "HTTPS"
      ssl_policy                  = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
      certificate_arn             = module.acm_load.acm_certificate_arn
      forward = {
        target_group_key = "ex-ip"
      }
    }
  }

  target_groups = {
    ex-ip = {
      name_prefix               = "l1-"
      target_type               = "ip"
      protocol                  = "HTTP"
      port                      = 8089
      create_attachment = false
      health_check = {
        enabled             = true
        interval            = 35
        port                = 8089
        healthy_threshold   = 3
        unhealthy_threshold = 5
        timeout             = 30
        protocol            = "HTTP"
        matcher             = "200"
      }
    }
  }

}


