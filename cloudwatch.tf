resource "aws_cloudwatch_log_group" "log-group" {
  #checkov:skip=CKV_AWS_158:KMS not required in prod
  #checkov:skip=CKV_AWS_338:12 months not required in prod
  name              = "/ecs/${var.container_name}"
  tags              = var.resource_tags
  provider          = aws.prod
  retention_in_days = 90
}

# __generated__ by Terraform from "heo/cartographer_ip_updater"
resource "aws_cloudwatch_log_group" "cartographer-ipupdater" {
  log_group_class   = "STANDARD"
  name              = "heo/cartographer_ip_updater"
  retention_in_days = 30
  skip_destroy      = false
  tags              = var.resource_tags
}

resource "aws_cloudwatch_metric_alarm" "ecs_service" {
  actions_enabled     = true
  alarm_actions       = [data.aws_sns_topic.sns_topic.arn]
  alarm_description   = "This metric monitors ecs cpu utilization"
  alarm_name          = "ECS CPU 80% Utilization: ${var.container_name} service"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 1
  dimensions = {
    ClusterName = "heo-inspect-cluster"
    ServiceName = "cartographer"
  }
  evaluation_periods = 1
  metric_name        = "CpuUtilized"
  namespace          = "ECS/ContainerInsights"
  period             = 60
  statistic          = "Maximum"
  threshold          = 800
  treat_missing_data = "ignore"
  tags               = var.resource_tags
  provider           = aws.prod

}

resource "aws_cloudwatch_metric_alarm" "ecs_cluster_rocket" {
  alarm_actions       = [data.aws_sns_topic.sns_topic.arn]
  alarm_description   = "This metric monitors ecs cpu utilization"
  alarm_name          = "ECS CPU 80% Utilization: ${var.container_name} cluster"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 1
  dimensions = {
    ClusterName = "heo-inspect-cluster"
    ServiceName = "cartographer"
  }
  evaluation_periods        = 1
  insufficient_data_actions = []
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  ok_actions                = []
  period                    = 60
  statistic                 = "Maximum"
  threshold                 = 80
  treat_missing_data        = "ignore"
  tags                      = var.resource_tags
  provider                  = aws.prod


}

resource "aws_cloudwatch_metric_alarm" "ec2_95_cpu_utilization_alarm" {
  alarm_name                = "CPU 95% Utilization: Cartographer DB"
  alarm_actions             = [data.aws_sns_topic.sns_topic.arn]
  actions_enabled           = true
  comparison_operator       = "GreaterThanThreshold"
  datapoints_to_alarm       = 1
  dimensions                = { InstanceId = aws_instance.instance.id }
  evaluation_periods        = 1
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 95
  alarm_description         = "This metric monitors the CPU utilization for the Cartographer DB Instance"
  insufficient_data_actions = []

  provider = aws.prod
}


#Cartographer Health Monitor Alarms

resource "aws_cloudwatch_log_metric_filter" "metric_filters" {
  for_each       = var.health_monitor_objects
  log_group_name = "/aws/lambda/${var.health_monitor_lambda}"
  name           = each.value.name
  pattern        = each.value.pattern
  metric_transformation {
    name      = each.value.name
    namespace = "cartographer"
    value     = "1"
  }
  provider = aws.prod
}

# __generated__ by Terraform from "/aws/lambda/cartographer-health-monitoring-lambda"
resource "aws_cloudwatch_log_group" "cartographer-health-monitor" {
  log_group_class   = "STANDARD"
  name              = "/aws/lambda/${var.health_monitor_lambda}"
  retention_in_days = 0
  skip_destroy      = false
  tags              = var.resource_tags
  provider          = aws.prod
}

resource "aws_cloudwatch_metric_alarm" "metric_filter_alarms" {
  for_each = var.health_monitors
  alarm_actions = concat(
    each.value.alarm_actions,
    [aws_sns_topic.cartographer_errors.arn]
  )
  alarm_description   = "${var.ecs_name} ${each.value.name} alert"
  alarm_name          = "${var.ecs_name} ${each.value.name} alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  datapoints_to_alarm = 1
  evaluation_periods  = 1
  metric_name         = each.value.name
  namespace           = var.ecs_name
  statistic           = "Sum"
  period              = "60"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  tags                = var.resource_tags
  provider            = aws.prod
}


## Okapi resources

resource "aws_cloudwatch_log_group" "okapi-etl-lambda" {
  log_group_class   = "STANDARD"
  name              = "/aws/lambda/cartographer-okapi-etl-lambda"
  retention_in_days = 180
  skip_destroy      = false
  tags              = var.resource_tags
  provider          = aws.prod
}

resource "aws_cloudwatch_log_metric_filter" "okapi_metric_filters" {
  log_group_name = aws_cloudwatch_log_group.okapi-etl-lambda.name
  name           = "General-Errors"
  pattern        = var.cw_metric_filter_pattern
  metric_transformation {
    name      = "cartographer"
    namespace = var.cartographer-okapi-etl-lambda
    value     = "1"
  }
  provider = aws.prod
}

resource "aws_cloudwatch_metric_alarm" "okapi_metric_filter_alarms" {
  alarm_actions       = [aws_sns_topic.cartographer_errors.arn]
  alarm_description   = "${var.cartographer-okapi-etl-lambda} Alert"
  alarm_name          = "${var.cartographer-okapi-etl-lambda} alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  #metric_name         = lookup(aws_cloudwatch_log_metric_filter.okapi_metric_filters.metric_transformation, "name")
  metric_name = aws_cloudwatch_log_metric_filter.okapi_metric_filters.metric_transformation[0].name
  #metric_name        = var.ecs_name
  namespace          = var.cartographer-okapi-etl-lambda
  statistic          = "Sum"
  period             = "60"
  threshold          = 1
  treat_missing_data = "notBreaching"
  tags               = var.resource_tags
  provider           = aws.prod
}


resource "aws_cloudwatch_log_metric_filter" "ipupdater_metric_filters" {
  log_group_name = "heo/cartographer_ip_updater"
  name           = "General Errors"
  pattern        = var.cw_metric_filter_pattern
  metric_transformation {
    name      = "cartographer"
    namespace = "Cartographer_IP_Updater"
    value     = "1"
  }
  provider = aws.prod
}

resource "aws_cloudwatch_metric_alarm" "ipupdater_metric_filter_alarms" {
  alarm_actions       = [aws_sns_topic.cartographer_errors.arn]
  alarm_description   = "Cartographer IP Updater Alert"
  alarm_name          = "Cartographer IP Updater alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.ipupdater_metric_filters.metric_transformation[0].name
  namespace           = "Cartographer_IP_Updater"
  statistic           = "Sum"
  period              = "60"
  threshold           = 0
  treat_missing_data  = "notBreaching"
  tags                = var.resource_tags
  provider            = aws.prod
}

resource "aws_cloudwatch_log_metric_filter" "cartographer_fatal_error_filters" {
  log_group_name = "/ecs/cartographer-prod"
  name           = "FATAL Errors"
  pattern        = "FATAL"
  metric_transformation {
    name      = "Cartographer_Fatal_Error"
    namespace = "cartographer"
    value     = "1"
  }
  provider = aws.prod
}

resource "aws_cloudwatch_metric_alarm" "cartographer_fatal_error_filter_alarms" {
  alarm_actions       = [aws_sns_topic.cartographer_errors.arn]
  alarm_description   = "Cartographer Fatal Error Alert"
  alarm_name          = "Cartographer Fatal Error alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.cartographer_fatal_error_filters.metric_transformation[0].name
  namespace           = "Cartographer_Fatal_Error"
  statistic           = "Sum"
  period              = "60"
  threshold           = 0
  treat_missing_data  = "notBreaching"
  tags                = var.resource_tags
  provider            = aws.prod
}

resource "aws_cloudwatch_log_group" "cartographer-external-ephemeris-etl-lambda" {
  log_group_class   = "STANDARD"
  name              = "/aws/lambda/cartographer-external-ephemeris-etl-lambda"
  retention_in_days = 180
  skip_destroy      = false
  tags              = var.resource_tags
  provider          = aws.prod
}

resource "aws_cloudwatch_log_metric_filter" "cartographer_queuepool_metric_filter" {
  log_group_name = aws_cloudwatch_log_group.log-group.name
  name           = "Cartographer DB QueuePool limit"
  pattern        = "TimeoutError QueuePool limit"
  metric_transformation {
    name      = "Cartographer_QueuePool_Limit"
    namespace = "cartographer"
    value     = "1"
  }
  provider = aws.prod
}

resource "aws_cloudwatch_metric_alarm" "cartographer_queuepool_metric_filter_alarms" {
  alarm_actions       = [aws_sns_topic.cartographer_errors.arn]
  alarm_description   = "Cartographer QueuePool limit Alert"
  alarm_name          = "Cartographer QueuePool limit alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.cartographer_queuepool_metric_filter.metric_transformation[0].name
  namespace           = "cartographer"
  statistic           = "Sum"
  period              = "60"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  tags                = var.resource_tags
  provider            = aws.prod
}
