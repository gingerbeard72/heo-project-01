# __generated__ by Terraform from "health_monitoring_lambda_r"
resource "aws_ecr_repository" "health_monitoring_lambda_r" {
  image_tag_mutability = "MUTABLE"
  name                 = "health_monitoring_lambda_r"
  tags                 = var.resource_tags
  encryption_configuration {
    encryption_type = "AES256"
  }
  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "lambda" {
  image_tag_mutability = "MUTABLE"
  name                 = "etl_lambda_r"
  tags                 = var.resource_tags
  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "external-ephemeris-etl-lambda" {
  image_tag_mutability = "MUTABLE"
  name                 = "external_ephemeris_etl_lambda_r"
  tags                 = var.resource_tags
  image_scanning_configuration {
    scan_on_push = false
  }
}
