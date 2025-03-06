

# __generated__ by Terraform from "cartographer-health-monitoring-lambda"
resource "aws_lambda_function" "cartographer-health-monitoring-lambda" {
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
    log_group  = aws_cloudwatch_log_group.cartographer-health-monitor.name
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
resource "aws_lambda_function" "cartographer-okapi-etl-lambda" {
  architectures                  = ["x86_64"]
  function_name                  = var.cartographer-okapi-etl-lambda
  image_uri                      = data.aws_ecr_image.okapi_etl_lambda.image_uri
  memory_size                    = 256
  package_type                   = "Image"
  reserved_concurrent_executions = -1
  role                           = aws_iam_role.okapi-etl-lambda-role.arn
  skip_destroy                   = false
  tags                           = var.resource_tags
  timeout                        = 900
  ephemeral_storage {
    size = 512
  }
  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.okapi-etl-lambda.name
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

# __generated__ by Terraform from "cartographer-external-ephemeris-etl-lambda"
resource "aws_lambda_function" "cartographer-external-ephemeris-etl-lambda" {
  provider                       = aws.prod
  architectures                  = ["x86_64"]
  function_name                  = "cartographer-external-ephemeris-etl-lambda"
  image_uri                      = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-southeast-2.amazonaws.com/cartographer_external_ephemeris_etl_lambda_r:latest"
  memory_size                    = 512
  package_type                   = "Image"
  reserved_concurrent_executions = -1
  role                           = aws_iam_role.cartographer-external-ephemeris-etl-lambda-role.arn
  skip_destroy                   = false
  tags                           = var.resource_tags
  timeout                        = 15
  ephemeral_storage {
    size = 512
  }
  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/cartographer-external-ephemeris-etl-lambda"
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

# __generated__ by Terraform from "cartographer-spacetrack-etl-lambda"
resource "aws_lambda_function" "cartographer-spacetrack-etl-lambda" {
  provider                       = aws.prod
  architectures                  = ["x86_64"]
  function_name                  = "cartographer-spacetrack-etl-lambda"
  image_uri                      = "048955030943.dkr.ecr.ap-southeast-2.amazonaws.com/cartographer_spacetrack_etl_lambda_r:latest"
  memory_size                    = 8196
  package_type                   = "Image"
  reserved_concurrent_executions = -1
  role                           = "arn:aws:iam::048955030943:role/service-role/cartographer-spacetrack-etl-lambda-role-riu0y136"
  skip_destroy                   = false
  tags                           = var.resource_tags
  timeout                        = 900
  ephemeral_storage {
    size = 10240
  }
  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/cartographer-spacetrack-etl-lambda"
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