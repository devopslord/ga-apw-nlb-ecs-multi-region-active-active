resource "aws_service_discovery_private_dns_namespace" "private" {
  name        = "t360-load-testing.test"
  description = "Private dns namespace for service discovery"
  vpc         = module.vpc_for_ecs_fargate.vpc_id
}

resource "aws_service_discovery_service" "this" {
  name = "locust-master"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.private.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "worker" {
  name = "locust-wkr"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.private.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}


##################################################
# build docker image


resource "aws_ecr_repository" "foo_load" {
  name                 = "${random_pet.this.id}-load_testing-image"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "null_resource" "build_locust-image" {
  provisioner "local-exec" {
    command = <<EOT
      docker build -t load_testing .
    EOT
    working_dir = "./Locust"
    interpreter = ["PowerShell", "-Command"]
  }
  
}


# loging to ecr

resource "null_resource" "login-ecr_load" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com
    EOT
  }
  
}

resource "null_resource" "tag_image_load" {
  provisioner "local-exec" {
    command = <<EOT
      docker tag load_testing:latest ${aws_ecr_repository.foo_load.repository_url}:latest
    EOT
    interpreter = ["PowerShell", "-Command"]
  }
  depends_on = [ null_resource.build_locust-image ]
}

resource "null_resource" "push_image_load" {
  provisioner "local-exec" {
    command = <<EOT
      docker push ${aws_ecr_repository.foo_load.repository_url}:latest
    EOT
    interpreter = ["PowerShell", "-Command"]
  
  }
  depends_on = [ null_resource.tag_image_load ]
  
}


module "ecs_cluster_load" {

  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "~> 5.0"
  depends_on = [ aws_ecr_repository.foo_load ]

  cluster_name = "Config360-${random_pet.this.id}-load_testing"

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }
}

module "ecs_service_load" {
  source = "terraform-aws-modules/ecs/aws//modules/service"
  name = "load_testing-svc-master"
  cluster_arn = module.ecs_cluster_load.arn
  cpu    = 2048
  memory = 4096


  load_balancer = {
    service = {
      target_group_arn = module.alb_load.target_groups["ex-ip"].arn
      container_name   = "load_testing_master"
      container_port   = 8089
    }
  }

  subnet_ids                         = module.vpc_for_ecs_fargate.private_subnet_ids
  desired_count                      = 1
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  
  service_registries = {
    registry_arn   = "${aws_service_discovery_service.this.arn}"
    container_name = "load_testing_master"
   }


  security_group_rules = {
    alb_ingress_8089 = {
      type                     = "ingress"
      from_port                = 8089
      to_port                  = 8089
      protocol                 = "tcp"
      description              = "Service port"
      cidr_blocks              = ["0.0.0.0/0"]
    }
    worker_ingress_5557 = {
      type                     = "ingress"
      from_port                = 5557
      to_port                  = 5557
      protocol                 = "tcp"
      description              = "Service port"
      cidr_blocks = ["0.0.0.0/0"]
    }
    alb_ingress_8089_sg = {
      type                     = "ingress"
      from_port                = 8089
      to_port                  = 8089
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = "${module.alb_load.security_group_id}"
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  container_definitions = {
    
    load_testing_master = {
      requires_compatibilities = ["FARGATE"]
      network_mode             = "awsvpc"
      cpu       = 512
      memory    = 1024
      essential = true
      image     = "${aws_ecr_repository.foo_load.repository_url}"
      command   = ["--master"]
      port_mappings = [
        {
          name          = "app-port"
          containerPort = 8089
          protocol      = "tcp"
        },
        {
          name          = "wkr-port"
          containerPort = 5557
          protocol      = "tcp"
        }
      ]



      enable_cloudwatch_logging = true
      log_configuration = {
        logDriver = "awslogs"
        options = {
          # Name                    = "awslogs-group"
          # region                  = "${var.region1}"
          awslogs-group = "load_testing-${random_pet.this.id}-task-logs"
          awslogs-region = "${var.region}"
          awslogs-stream-prefix = "locust-master"
          awslogs-create-group = "true"
        #   log-driver-buffer-limit = "2097152"
        }
      }
  }
   
  }
}

module "ecs_service_load_wrk" {
  source = "terraform-aws-modules/ecs/aws//modules/service"
  name = "load_testing-svc-wrk"
  cluster_arn = module.ecs_cluster_load.arn
  cpu    = 2048
  memory = 4096

  subnet_ids                         = module.vpc_for_ecs_fargate.private_subnet_ids
  desired_count                      = 5
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  service_registries = {
    registry_arn   = "${aws_service_discovery_service.worker.arn}"
    container_name = "load_testing_wkr"
   }


  security_group_rules = {
    alb_ingress_8089 = {
      type                     = "ingress"
      from_port                = 8089
      to_port                  = 8089
      protocol                 = "tcp"
      description              = "Service port"
      cidr_blocks              = ["0.0.0.0/0"]
    }
    worker_ingress_5557 = {
      type                     = "ingress"
      from_port                = 5557
      to_port                  = 5557
      protocol                 = "tcp"
      description              = "Service port"
      cidr_blocks = ["0.0.0.0/0"]
    }
    alb_ingress_8089_sg = {
      type                     = "ingress"
      from_port                = 8089
      to_port                  = 8089
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = "${module.alb_load.security_group_id}"
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  container_definitions = {
    
    load_testing_wkr = {
      requires_compatibilities = ["FARGATE"]
      network_mode             = "awsvpc"
      cpu       = "${var.cpu}"
      memory    = "${var.memory}"
      essential = true
      image     = "${aws_ecr_repository.foo_load.repository_url}"
      command   = ["--worker", "--master-host", "locust-master.t360-load-testing.test"]

      enable_cloudwatch_logging = true
      log_configuration = {
        logDriver = "awslogs"
        options = {
          # Name                    = "awslogs-group"
          # region                  = "${var.region1}"
          awslogs-group = "load_testing-${random_pet.this.id}-task-logs"
          awslogs-region = "${var.region}"
          awslogs-stream-prefix = "locust-worker"
          awslogs-create-group = "true"
        #   log-driver-buffer-limit = "2097152"
        }
      }
    }
   
  }
}




resource "aws_cloudwatch_log_group" "rabbitmq" {
  name = "load_testing-${random_pet.this.id}-task-logs"
  retention_in_days = 1
}
