resource "aws_ecs_task_definition" "main" {
  family             = var.name
  task_role_arn = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.main_ecs_tasks.arn
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu    = var.fargate_cpu
  memory = var.fargate_memory
  container_definitions = jsonencode([
    {
      name : var.name,
      image : var.app_image,
      cpu : var.fargate_cpu,
      memory : var.fargate_memory,
      networkMode : "awsvpc",
      portMappings : [
        {
          containerPort : var.app_port
          protocol : "tcp",
          hostPort : var.app_port
        }
      ],
      secrets : [
        {
            name : "TICKET360_DbConfiguration__Hostname"
            valueFrom : "${var.secret_arn}:host::"
        },
        {
            name : "TICKET360_DbConfiguration__Database"
            valueFrom : "${var.secret_arn}:dbname::"
        }
      ],

      environment : [
        {
          name : "TICKET360_DbConfiguration__Username"
          value : "dev_iam_ticket"
        }
      ],
      logConfiguration : {
        logDriver : "awslogs",
        options : {
          awslogs-group : "T360-Tickets-API-${var.region}-task-logs",
          awslogs-region : "${var.region}",
          awslogs-stream-prefix : "T360-Tickets-API",
          awslogs-create-group : "true"
        
        }
      }
    }
  ])
}