resource "aws_ecs_task_definition" "ecs_task_definition_app" {
  depends_on               = [aws_instance.instance]
  family                   = "${var.container_name}-app"
  task_role_arn            = aws_iam_role.taskexecution-role.arn
  execution_role_arn       = aws_iam_role.ecs-web-role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "8192"
  memory                   = "24576"
  provider                 = aws.prod
  tags                     = var.resource_tags
  container_definitions = jsonencode([
    {
      cpu       = 0
      essential = true
      environment = [
        {
          name  = "DB_USERNAME",
          value = "${local.json_data.db_username}"
        },
        {
          name  = "DB_HOST",
          value = "${local.json_data.db_host}"
        },
        {
          name  = "DB_PORT",
          value = "${local.json_data.db_port}"
        },
      ]
      secrets = [
        {
          "name" : "DB_PASSWORD",
          "valueFrom" : "${data.aws_secretsmanager_secret_version.secret_version.arn}:DB_PASSWORD::"
        }
      ]

      name  = "${var.ecs_name}-app"
      image = "${var.ecr_image}"
      runtimePlatform = {
        operatingSystemFamily = "LINUX"
      }
      portMappings = [
        {
          containerPort = 4305
          hostPort      = 4305
          name          = "app"
          protocol      = "tcp"
        }
      ]
      mountPoints    = []
      systemControls = []
      volumesFrom    = []
      network_configuration = {
        hostname = "app"
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.container_name}"
          "awslogs-region"        = "ap-southeast-2"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "ecs_service_app" {
  cluster                 = data.aws_ecs_cluster.cluster.arn
  depends_on              = [aws_ecs_task_definition.ecs_task_definition_app]
  desired_count           = 1
  enable_ecs_managed_tags = true
  enable_execute_command  = true
  launch_type             = "FARGATE"
  wait_for_steady_state   = false
  name                    = var.ecs_name

  network_configuration {
    security_groups = [
      data.aws_security_group.sec-group.id
    ]
    subnets = [
      data.aws_subnet.compute-private-subnet-1.id,
      data.aws_subnet.compute-private-subnet-2.id,
      data.aws_subnet.compute-private-subnet-3.id
    ]
    assign_public_ip = false
  }
  task_definition = aws_ecs_task_definition.ecs_task_definition_app.arn
  provider        = aws.prod
  tags            = var.resource_tags
}
