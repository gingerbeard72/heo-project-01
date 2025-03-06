data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_role" "heo_web_role" {
  name     = "heo-web-role"
  provider = aws.prod
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_iam_role" "ecsEventsRole" {
  name = "ecsEventsRole"
}

data "aws_security_group" "sec-group" {
  id       = "sg-0ceb4a4bb00e213a6"
  provider = aws.prod
}

data "aws_subnet" "compute-private-subnet-1" {
  id       = "subnet-0c421eb89c3eb1c71"
  provider = aws.prod
}

data "aws_subnet" "compute-private-subnet-2" {
  id       = "subnet-062218afb039e4d35"
  provider = aws.prod
}

data "aws_subnet" "compute-private-subnet-3" {
  id       = "subnet-08711ee027f09507b"
  provider = aws.prod
}

data "aws_subnet" "lambda-private-subnet-1" {
  id       = "subnet-0619e325ea6a3212f"
  provider = aws.prod
}

data "aws_subnet" "lambda-private-subnet-2" {
  id       = "subnet-0db9f1772eed142de"
  provider = aws.prod
}

data "aws_subnet" "lambda-private-subnet-3" {
  id       = "subnet-004889b194e85eee7"
  provider = aws.prod
}

data "aws_vpc" "heo-prod-vpc" {
  id       = "vpc-024f12733fb90d59c"
  provider = aws.prod
}

data "aws_ecs_cluster" "heo-inspect-cluster" {
  cluster_name = "heo-inspect-cluster"
  provider     = aws.prod
}

data "aws_sns_topic" "sns_topic" {
  name     = "heo-prod-infra-alerts"
  provider = aws.prod
}

data "aws_ssm_parameter" "cartographer" {
  name     = "heo-cartographer-config"
  provider = aws.prod
}

data "aws_key_pair" "cartographer-db" {
  key_name = "cartographer-db"
  provider = aws.prod
}

data "aws_ecr_image" "cartographer_r" {
  repository_name = "cartographer_r"
  image_tag       = "latest"
  provider        = aws.prod
}

data "aws_ecr_image" "okapi_etl_lambda" {
  repository_name = "cartographer_okapi_etl_lambda_r"
  image_tag       = "latest"
  provider        = aws.prod
}

data "aws_ecr_image" "health_monitoring" {
  repository_name = "cartographer_health_monitoring_lambda_r"
  image_tag       = "latest"
  provider        = aws.prod
}

data "aws_ecr_image" "devops" {
  repository_name = "devops-tf-testing"
  image_tag       = "latest"
  provider        = aws.prod
}

data "aws_secretsmanager_secret" "cartographer_db_secret" {
  name     = "cartographer/db"
  provider = aws.prod
}

data "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = data.aws_secretsmanager_secret.cartographer_db_secret.id
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

data "aws_iam_policy_document" "ecs_task_permissions" {
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
      "arn:aws:route53:::hostedzone/Z01042851YOY0GTT8KZ17",
      "arn:aws:ecs:ap-southeast-2:048955030943:container-instance/heo-inspect-cluster/*",
      "arn:aws:ecs:ap-southeast-2:048955030943:task/heo-inspect-cluster/*"
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
      "${aws_cloudwatch_log_group.cartographer-health-monitor.arn}",
      "${aws_ssm_parameter.cartographer-cartographer_health_monitoring_lambda.arn}"
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "cartographer_secrets" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "ssm:GetParameters",
      "kms:Decrypt"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:secretsmanager:ap-southeast-2:048955030943:secret:cartographer/db-RTcy0m"
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

data "aws_lambda_function" "cartographer-spacetrack-etl-lambda" {
  function_name = "cartographer-spacetrack-etl-lambda"
  provider      = aws.prod
}

data "aws_iam_policy_document" "cartographer-external-ephemeris-etl-lambda" {
  statement {
    actions = [
      "logs:PutLogEvents",
      "ssm:GetParameter"
    ]
    effect = "Allow"
    resources = [
      aws_cloudwatch_log_group.cartographer-external-ephemeris-etl-lambda.arn,
      aws_ssm_parameter.cartographer-external-ephemeris-etl-lambda-config.arn
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
      "arn:aws:s3:::heo-cartographer-00"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject"
    ]
    resources = ["arn:aws:s3:::heo-cartographer-00/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "cartographer-external-ephemeris-etl-lambda-assume-role-policy" {
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
