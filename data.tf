data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_role" "role" {
  name     = "role"
  provider = aws.prod
}

data "aws_iam_role" "task_execution_role" {
  name = "TaskExecutionRole"
}

data "aws_iam_role" "EventsRole" {
  name = "EventsRole"
}

data "aws_security_group" "sec-group" {
  id       = "sg-"
  provider = aws.prod
}

data "aws_subnet" "compute-private-subnet-1" {
  id       = "subnet-"
  provider = aws.prod
}

data "aws_subnet" "compute-private-subnet-2" {
  id       = "subnet-"
  provider = aws.prod
}

data "aws_subnet" "compute-private-subnet-3" {
  id       = "subnet-"
  provider = aws.prod
}

data "aws_subnet" "lambda-private-subnet-1" {
  id       = "subnet-"
  provider = aws.prod
}

data "aws_subnet" "lambda-private-subnet-2" {
  id       = "subnet-"
  provider = aws.prod
}

data "aws_subnet" "lambda-private-subnet-3" {
  id       = "subnet-"
  provider = aws.prod
}

data "aws_vpc" "-prod-vpc" {
  id       = "vpc-"
  provider = aws.prod
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = "cluster"
  provider     = aws.prod
}

data "aws_sns_topic" "sns_topic" {
  name     = "infra-alerts"
  provider = aws.prod
}

data "aws_ssm_parameter" "parameter" {
  name     = "-config"
  provider = aws.prod
}

data "aws_key_pair" "-db" {
  key_name = "-db"
  provider = aws.prod
}

data "aws_ecr_image" "_r" {
  repository_name = "_r"
  image_tag       = "latest"
  provider        = aws.prod
}

data "aws_ecr_image" "_etl_lambda" {
  repository_name = "__etl_lambda_r"
  image_tag       = "latest"
  provider        = aws.prod
}

data "aws_ecr_image" "health_monitoring" {
  repository_name = "_health_monitoring_lambda_r"
  image_tag       = "latest"
  provider        = aws.prod
}

data "aws_ecr_image" "devops" {
  repository_name = "devops-tf-testing"
  image_tag       = "latest"
  provider        = aws.prod
}

data "aws_secretsmanager_secret" "_db_secret" {
  name     = "/db"
  provider = aws.prod
}

data "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = data.aws_secretsmanager_secret._db_secret.id
  provider  = aws.prod
}

data "aws_iam_policy_document" "scheduler" {
  statement {
    actions = [
      "lambda:InvokeFunction"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "k_permissions" {
  statement {
    actions = [
      "ecs:ListTasks",
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
      "ecs:DescribeTasks",
      "route53:ListHostedZones",
    ]
    effect = "Allow"
    resources = [
      "arn:aws:route53:::hostedzone/",
      "arn:aws:ecs:ap-southeast-2::container-instance/cluster/*",
      "arn:aws:ecs:ap-southeast-2::task/cluster/*"
    ]
  }
}

data "aws_iam_policy_document" "health_monitor_policy" {
  statement {
    actions = [
      "logs:PutLogEvents",
      "ssm:GetParameter"
    ]
    resources = [
      "${aws_cloudwatch_log_group.-health-monitor.arn}",
      "${aws_ssm_parameter.-_health_monitoring_lambda.arn}"
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "_secrets" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "ssm:GetParameters",
      "kms:Decrypt"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:secretsmanager:ap-southeast-2::secret:/db-RTcy0m"
    ]
  }
  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:route53:::hostedzone/*",
    ]
  }
}

data "aws_lambda_function" "-spacetrack-etl-lambda" {
  function_name = "-spacetrack-etl-lambda"
  provider      = aws.prod
}

data "aws_iam_policy_document" "-external-ephemeris-etl-lambda" {
  statement {
    actions = [
      "logs:PutLogEvents",
      "ssm:GetParameter"
    ]
    effect = "Allow"
    resources = [
      aws_cloudwatch_log_group.-external-ephemeris-etl-lambda.arn,
      aws_ssm_parameter.-external-ephemeris-etl-lambda-config.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "logs:CreateLogGroup"
    ]
    resources = [
      "arn:aws:logs:ap-southeast-2:${data.aws_caller_identity.current.account_id}:*",
      "arn:aws:s3:::--00"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject"
    ]
    resources = ["arn:aws:s3:::--00/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "-external-ephemeris-etl-lambda-assume-role-policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
