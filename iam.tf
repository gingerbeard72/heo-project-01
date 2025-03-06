resource "aws_iam_policy" "s3_policy" {
  name        = "${var.environment}s3-access"
  path        = "/"
  description = "${var.environment}s3-access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListAllMyBuckets",
          "s3:ListBucket",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:PutObject"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::",
          "arn:aws:s3:::/*"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "ecs-web-role" {
  name = "${var.environment}web-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "events.amazonaws.com",
            "ecs-tasks.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "Task_run" {
  name = "Task_role"
  role = aws_iam_role.ecs-web-role.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : "ecs:RunTask",
          "Resource" : "*"
        },
        {
          "Sid" : "VisualEditor1",
          "Effect" : "Allow",
          "Action" : "iam:PassRole",
          "Resource" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"
        }
      ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment_ContainerRegistry" {
  role       = aws_iam_role.ecs-web-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment_web_role_task_execution" {
  role       = aws_iam_role.ecs-web-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment_web_role_AmazonRDSDataFullAccess" {
  role       = aws_iam_role.ecs-web-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment_web_role_ask_execution" {
  role       = aws_iam_role.ecs-web-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment_web_role_AmazonSSMFullAccess" {
  role       = aws_iam_role.ecs-web-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment_web_role_AWSLambda" {
  role       = aws_iam_role.ecs-web-role.id
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment_web_role_SecretsManager" {
  role       = aws_iam_role.ecs-web-role.id
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role" "taskexecution-role" {
  name = "heotaskexecution-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "ecs-tasks.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ecs-task-permissions" {
  name        = "prodecs-task-permissions"
  description = "cartographer ecs task"
  policy      = data.aws_iam_policy_document.ecs_task_permissions.json
}

resource "aws_iam_role_policy_attachment" "ecs-task-permissions" {
  role       = aws_iam_role.taskexecution-role.id
  policy_arn = aws_iam_policy.ecs-task-permissions.arn
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment_AmazonECSTaskExecutionRolePolicy" {
  role       = aws_iam_role.taskexecution-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment_AmazonSSMReadOnlyAccess" {
  role       = aws_iam_role.taskexecution-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment_AmazonSSMInstanceCore" {
  role       = aws_iam_role.taskexecution-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "ecs_policy_attachment_secretsmanager" {
  role       = aws_iam_role.taskexecution-role.id
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment_CloudWatchAgentServerPolicy" {
  role       = aws_iam_role.taskexecution-role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}


resource "aws_iam_role_policy_attachment" "ecs_policy_attachment_s3_access" {
  role       = aws_iam_role.taskexecution-role.id
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_policy" "cartographer_secrets" {
  name        = "${var.environment}secret"
  path        = "/"
  description = "Cartographer secrets manager access"
  policy      = data.aws_iam_policy_document.cartographer_secrets.json
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment_secrets_manager" {
  role       = aws_iam_role.taskexecution-role.id
  policy_arn = aws_iam_policy.cartographer_secrets.arn
}


## EventBridge Schedule role

resource "aws_iam_role" "scheduler" {
  assume_role_policy = file("${path.module}/scheduler-execution-role.json")
  inline_policy {
    name = "scheduler"

  }
}

resource "aws_iam_policy" "scheduler" {
  name        = "prodschedulers"
  description = "cartographer scheduler"
  policy      = data.aws_iam_policy_document.scheduler.json
}

resource "aws_iam_role_policy_attachment" "scheduler" {
  role       = aws_iam_role.scheduler.name
  policy_arn = aws_iam_policy.scheduler.arn
}

## Health Monitor Lambda role and policies

resource "aws_iam_role_policy" "health_monitor_policy" {
  name = "health_monitor_policy"
  #policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"logs:PutLogEvents\"],\"Effect\":\"Allow\",\"Resource\":[\"${aws_cloudwatch_log_group.health-monitor.arn}\"],\"Sid\":\"VisualEditor0\"}]}"
  policy = data.aws_iam_policy_document.health_monitor_policy.json
  role   = aws_iam_role.health_monitor.name
}

resource "aws_iam_role" "health_monitor" {
  assume_role_policy = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"}}],\"Version\":\"2012-10-17\"}"
  description        = "Cartographer Health Monitor role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  ]
  max_session_duration = 3600
  name                 = "${var.health_monitor_lambda}-role"
  path                 = "/service-role/"
  tags                 = var.resource_tags
}

## Okapi IAM resources

resource "aws_iam_role" "okapi-etl-lambda-role" {
  assume_role_policy    = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"}}],\"Version\":\"2012-10-17\"}"
  description           = "okapi-etl-lambda-role"
  force_detach_policies = false
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  ]
  max_session_duration = 3600
  name                 = "okapi-etl-lambda-role"
  path                 = "/service-role/"
  tags                 = var.resource_tags
}

resource "aws_iam_role_policy" "okapi_role" {
  name = "${var.environment}-okapi_role"
  role = aws_iam_role.okapi-etl-lambda-role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "ssm:GetParameter",
          "kms:Decrypt"
        ],
        "Resource" : [
          "arn:aws:secretsmanager:ap-southeast-2:048955030943:secret:heo_prod/okapi-creds-VZNgBx",
          "${aws_ssm_parameter.okapi-etl-config.arn}"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "external-ephemeris-etl-lambda-role" {
  assume_role_policy    = data.aws_iam_policy_document.external-ephemeris-etl-lambda-assume-role-policy.json
  description           = "external-ephemeris-etl-lambda-role"
  force_detach_policies = false
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
    aws_iam_policy.external-ephemeris-etl-lambda-policy.arn
  ]
  max_session_duration = 3600
  name                 = "external-ephemeris-etl-lambda-role"
  path                 = "/"
  tags                 = var.resource_tags
}

resource "aws_iam_policy" "external-ephemeris-etl-lambda-policy" {
  description = "external-ephemeris-etl-lambda IAM policy"
  name        = "external-ephemeris-etl-lambda-policy"
  path        = "/"
  policy      = data.aws_iam_policy_document.external-ephemeris-etl-lambda.json
}

resource "aws_iam_role_policy_attachment" "external-ephemeris-etl-lambda-attachment" {
  role       = aws_iam_role.external-ephemeris-etl-lambda-role.name
  policy_arn = aws_iam_policy.external-ephemeris-etl-lambda-policy.arn
}
