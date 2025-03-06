resource "aws_sns_topic" "_errors" {
  display_name = "${var.ecs_name}-errors"
  name         = "${var.ecs_name}-errors"
  tags         = var.resource_tags
}
