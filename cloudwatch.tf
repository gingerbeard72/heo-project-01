resource "aws_cloudwatch_log_group" "log-group" {
  #checkov:skip=CKV_AWS_158:KMS not required in prod
  #checkov:skip=CKV_AWS_338:12 months not required in prod
  name              = "/ecs/${var.container_name}"
  tags              = var.resource_tags
  provider          = aws.prod
  retention_in_days = 90
}

# __generated__ by Terraform from "heo/_ip_updater"
resource "aws_cloudwatch_log_group" "-ipupdater" {
  log_group_class   = "STANDARD"
  name              = "heo/_ip_updater"
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
    ServiceName = ""
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

resource "aws_cloudwatch_metric_alarm" "ecs_cluster_" {
  alarm_actions       = [data.aws_sns_topic.sns_topic.arn]
  alarm_description   = "This metric monitors ecs cpu utilization"
  alarm_name          = "ECS CPU 80% Utilization: ${var.container_name} cluster"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 1
  dimensions = {
    ClusterName = "heo-inspect-cluster"
    ServiceName = ""
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
  alarm_name                = "CPU 95% Utilization:  DB"
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
  alarm_description         = "This metric monitors the CPU utilization for the  DB Instance"
  insufficient_data_actions = []

  provider = aws.prod
}


# Health Monitor Alarms

resource "aws_cloudwatch_log_metric_filter" "metric_filters" {
  for_each       = var.health_monitor_objects
  log_group_name = "/aws/lambda/${var.health_monitor_lambda}"
  name           = each.value.name
  pattern        = each.value.pattern
  metric_transformation {
    name      = each.value.name
    namespace = ""
    value     = "1"
  }
  provider = aws.prod
}

# __generated__ by Terraform from "/aws/lambda/-health-monitoring-lambda"
resource "aws_cloudwatch_log_group" "-health-monitor" {
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
    [aws_sns_topic._errors.arn]
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


##  resources

resource "aws_cloudwatch_log_group" "-etl-lambda" {
  log_group_class   = "STANDARD"
  name              = "/aws/lambda/--etl-lambda"
  retention_in_days = 180
  skip_destroy      = false
  tags              = var.resource_tags
  provider          = aws.prod
}

resource "aws_cloudwatch_log_metric_filter" "_metric_filters" {
  log_group_name = aws_cloudwatch_log_group.-etl-lambda.name
  name           = "General-Errors"
  pattern        = var.cw_metric_filter_pattern
  metric_transformation {
    name      = ""
    namespace = var.--etl-lambda
    value     = "1"
  }
  provider = aws.prod
}

resource "aws_cloudwatch_metric_alarm" "_metric_filter_alarms" {
  alarm_actions       = [aws_sns_topic._errors.arn]
  alarm_description   = "${var.--etl-lambda} Alert"
  alarm_name          = "${var.--etl-lambda} alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  #metric_name         = lookup(aws_cloudwatch_log_metric_filter._metric_filters.metric_transformation, "name")
  metric_name = aws_cloudwatch_log_metric_filter._metric_filters.metric_transformation[0].name
  #metric_name        = var.ecs_name
  namespace          = var.--etl-lambda
  statistic          = "Sum"
  period             = "60"
  threshold          = 1
  treat_missing_data = "notBreaching"
  tags               = var.resource_tags
  provider           = aws.prod
}


resource "aws_cloudwatch_log_metric_filter" "ipupdater_metric_filters" {
  log_group_name = "heo/_ip_updater"
  name           = "General Errors"
  pattern        = var.cw_metric_filter_pattern
  metric_transformation {
    name      = ""
    namespace = "_IP_Updater"
    value     = "1"
  }
  provider = aws.prod
}

resource "aws_cloudwatch_metric_alarm" "ipupdater_metric_filter_alarms" {
  alarm_actions       = [aws_sns_topic._errors.arn]
  alarm_description   = " IP Updater Alert"
  alarm_name          = " IP Updater alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.ipupdater_metric_filters.metric_transformation[0].name
  namespace           = "_IP_Updater"
  statistic           = "Sum"
  period              = "60"
  threshold           = 0
  treat_missing_data  = "notBreaching"
  tags                = var.resource_tags
  provider            = aws.prod
}

resource "aws_cloudwatch_log_metric_filter" "_fatal_error_filters" {
  log_group_name = "/ecs/-prod"
  name           = "FATAL Errors"
  pattern        = "FATAL"
  metric_transformation {
    name      = "_Fatal_Error"
    namespace = ""
    value     = "1"
  }
  provider = aws.prod
}

resource "aws_cloudwatch_metric_alarm" "_fatal_error_filter_alarms" {
  alarm_actions       = [aws_sns_topic._errors.arn]
  alarm_description   = " Fatal Error Alert"
  alarm_name          = " Fatal Error alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter._fatal_error_filters.metric_transformation[0].name
  namespace           = "_Fatal_Error"
  statistic           = "Sum"
  period              = "60"
  threshold           = 0
  treat_missing_data  = "notBreaching"
  tags                = var.resource_tags
  provider            = aws.prod
}

resource "aws_cloudwatch_log_group" "-external-ephemeris-etl-lambda" {
  log_group_class   = "STANDARD"
  name              = "/aws/lambda/-external-ephemeris-etl-lambda"
  retention_in_days = 180
  skip_destroy      = false
  tags              = var.resource_tags
  provider          = aws.prod
}

resource "aws_cloudwatch_log_metric_filter" "_queuepool_metric_filter" {
  log_group_name = aws_cloudwatch_log_group.log-group.name
  name           = " DB QueuePool limit"
  pattern        = "TimeoutError QueuePool limit"
  metric_transformation {
    name      = "_QueuePool_Limit"
    namespace = ""
    value     = "1"
  }
  provider = aws.prod
}

resource "aws_cloudwatch_metric_alarm" "_queuepool_metric_filter_alarms" {
  alarm_actions       = [aws_sns_topic._errors.arn]
  alarm_description   = " QueuePool limit Alert"
  alarm_name          = " QueuePool limit alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter._queuepool_metric_filter.metric_transformation[0].name
  namespace           = ""
  statistic           = "Sum"
  period              = "60"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  tags                = var.resource_tags
  provider            = aws.prod
}
