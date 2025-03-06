# __generated__ by Terraform from "cartographer_health_monitoring_lambda_r"
resource "aws_ecr_repository" "cartographer_health_monitoring_lambda_r" {
  image_tag_mutability = "MUTABLE"
  name                 = "cartographer_health_monitoring_lambda_r"
  tags                 = var.resource_tags
  encryption_configuration {
    encryption_type = "AES256"
  }
  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "okapi_lambda" {
  image_tag_mutability = "MUTABLE"
  name                 = "cartographer_okapi_etl_lambda_r"
  tags                 = var.resource_tags
  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "cartographer-external-ephemeris-etl-lambda" {
  image_tag_mutability = "MUTABLE"
  name                 = "cartographer_external_ephemeris_etl_lambda_r"
  tags                 = var.resource_tags
  image_scanning_configuration {
    scan_on_push = false
  }
}
