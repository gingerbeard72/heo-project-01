

# __generated__ by Terraform from "health-monitoring-lambda"
resource "aws_lambda_function" "health-monitoring-lambda" {
  architectures = ["x86_64"]
  function_name = var.health_monitor_lambda
  #image_uri                      = "${data.aws_caller_identity.current.account_id}.${var.health_monitor_lambda_uri}"
  image_uri                      = data.aws_ecr_image.health_monitoring.image_uri
  memory_size                    = 128
  package_type                   = "Image"
  reserved_concurrent_executions = -1
  role                           = aws_iam_role.health_monitor.arn
  skip_destroy                   = false
  tags                           = var.resource_tags
  timeout                        = 900
  ephemeral_storage {
    size = 512
  }
  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.health-monitor.name
  }
  tracing_config {
    mode = "PassThrough"
  }
  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids = [
      data.aws_security_group.sec-group.id
    ]
    subnet_ids = local.subnet_ids
  }
  provider = aws.prod
}


## Okapi Lambda
resource "aws_lambda_function" "-lambda" {
  architectures                  = ["x86_64"]
  function_name                  = var.-lambda
  image_uri                      = data.aws_ecr_image._lambda.image_uri
  memory_size                    = 256
  package_type                   = "Image"
  reserved_concurrent_executions = -1
  role                           = aws_iam_role.-lambda-role.arn
  skip_destroy                   = false
  tags                           = var.resource_tags
  timeout                        = 900
  ephemeral_storage {
    size = 512
  }
  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.-lambda.name
  }
  tracing_config {
    mode = "PassThrough"
  }
  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids = [
      data.aws_security_group.sec-group.id
    ]
    subnet_ids = local.subnet_ids
  }
}

# __generated__ by Terraform from "external-ephemeris-etl-lambda"
resource "aws_lambda_function" "external-ephemeris-etl-lambda" {
  provider                       = aws.prod
  architectures                  = ["x86_64"]
  function_name                  = "external-ephemeris-etl-lambda"
  image_uri                      = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-southeast-2.amazonaws.com/external_ephemeris_etl_lambda_r:latest"
  memory_size                    = 512
  package_type                   = "Image"
  reserved_concurrent_executions = -1
  role                           = aws_iam_role.external-ephemeris-etl-lambda-role.arn
  skip_destroy                   = false
  tags                           = var.resource_tags
  timeout                        = 15
  ephemeral_storage {
    size = 512
  }
  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/external-ephemeris-etl-lambda"
  }
  tracing_config {
    mode = "PassThrough"
  }
  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids = [
      data.aws_security_group.sec-group.id
    ]
    subnet_ids = local.lambda_subnet_ids
  }
}

# __generated__ by Terraform from "etl-lambda"
resource "aws_lambda_function" "etl-lambda" {
  provider                       = aws.prod
  architectures                  = ["x86_64"]
  function_name                  = "etl-lambda"
  image_uri                      = ".dkr.ecr.ap-southeast-2.amazonaws.com/etl_lambda_r:latest"
  memory_size                    = 8196
  package_type                   = "Image"
  reserved_concurrent_executions = -1
  role                           = "arn:aws:iam:::role/service-role/etl-lambda-role-"
  skip_destroy                   = false
  tags                           = var.resource_tags
  timeout                        = 900
  ephemeral_storage {
    size = 10240
  }
  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/etl-lambda"
  }
  tracing_config {
    mode = "PassThrough"
  }
  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids          = [data.aws_security_group.sec-group.id]
    subnet_ids = [
      data.aws_subnet.lambda-private-subnet-1.id,
      data.aws_subnet.lambda-private-subnet-2.id,
      data.aws_subnet.lambda-private-subnet-3.id
    ]
  }
}
