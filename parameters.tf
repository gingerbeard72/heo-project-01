resource "aws_ssm_parameter" "ecsparameter" {
  #checkov:skip=CKV_AWS_337:Not required in prod
  #checkov:skip=CKV2_AWS_34:Not required in prod
  insecure_value = file("./ecs_cartographer.json")
  name           = "ecs_${var.ecs_name}"
  type           = "String"
  provider       = aws.prod
  tags           = var.resource_tags
}

resource "aws_ssm_parameter" "cartographer-config" {
  #checkov:skip=CKV_AWS_337:Not required in prod
  #checkov:skip=CKV2_AWS_34:Not required in prod
  description = "Authentication and configuration strings for Cartographer."
  name        = "heo-cartographer-config"
  type        = "String"
  tags        = var.resource_tags
  provider    = aws.prod
  value       = file("./heo-cartographer-config.json")
}


resource "aws_ssm_parameter" "cartographer-spacetrack-etl" {
  #checkov:skip=CKV_AWS_337:Not required in prod
  #checkov:skip=CKV2_AWS_34:Not required in prod
  description = "Cartographer Spacetrack ETL parameters"
  name        = "cartographer-spacetrack-etl-config"
  type        = "String"
  tags        = var.resource_tags
  provider    = aws.prod
  value       = file("./cartographer-spacetrack-etl-config.json")
}


resource "aws_ssm_parameter" "cartographer-okapi-etl-config" {
  data_type   = "text"
  description = var.cartographer-okapi-etl-lambda
  name        = "cartographer-okapi-etl-config"
  tags        = var.resource_tags
  tier        = "Standard"
  type        = "String"
  value       = (file("./okapi-etl-config.json"))
  provider    = aws.prod

}

resource "aws_ssm_parameter" "cartographer-cartographer_health_monitoring_lambda" {
  data_type   = "text"
  description = "cartographer-health-monitoring-lambda-config"
  name        = "cartographer-health-monitoring-lambda-config"
  tags        = var.resource_tags
  tier        = "Standard"
  type        = "String"
  value       = (file("./cartographer-health-monitoring-lambda-config.json"))
  provider    = aws.prod
}

# __generated__ by Terraform
resource "aws_ssm_parameter" "cartographer-external-ephemeris-etl-lambda-config" {
  data_type   = "text"
  description = "cartographer-external-ephemeris-etl-lambda-config parameters"
  name        = "cartographer-external-ephemeris-etl-lambda-config"
  tags        = var.resource_tags
  tier        = "Standard"
  type        = "String"
  value       = (file("./cartographer-external-ephemeris-etl-lambda-config.json"))
  provider    = aws.prod
}
