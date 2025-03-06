output "ecs_service_app" {
  value       = aws_ecs_service.ecs_service_app.name
  description = "ECS Service information for the Cartographer App Service"
}

output "ECS_task_def_app" {
  value       = aws_ecs_task_definition.ecs_task_definition_app.id
  description = "Cartographer App Task definition"
  #sensitive   = true
}

output "Cloudwatch_logs" {
  value       = aws_cloudwatch_log_group.log-group.name
  description = "The Cloudwatch Log group for the Cartographer Service"
}

output "cloudwatch_alarm" {
  value       = aws_cloudwatch_metric_alarm.ecs_service.alarm_name
  description = "Cloudwatch Metric Alarm output"
}

output "web_role" {
  value       = aws_iam_role.cartographer-ecs-web-role.name
  description = "Cartographer web role"
}

output "task_role" {
  value       = aws_iam_role.cartographer-taskexecution-role.name
  description = "Cartographer task execution role"
}

# Show the public IP of the newly created instance
output "instance" {
  value = aws_instance.instance.id
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "locals" {
  value = local.json_data
}
output "subnets" {
  value = local.subnet_ids
}

output "sns_topic" {
  value = aws_sns_topic.cartographer_errors.name
}

output "metric_filter_alarms" {
  value       = [for alarm in aws_cloudwatch_metric_alarm.metric_filter_alarms : alarm.alarm_name]
  description = "Cloudwatch Metric Alarm output"
}

output "log_metric_filter" {
  value       = [for filter in aws_cloudwatch_log_metric_filter.metric_filters : filter.name]
  description = "Cloudwatch Metric Alarm output"
}

output "okapi_etl_Schedule" {
  value = aws_scheduler_schedule.cartographer-okapi-etl.name
}

output "astroscale_etl_Schedule" {
  value = aws_scheduler_schedule.cartographer-etl-astroscale-load.name
}

output "etl_omm_Schedule" {
  value = aws_scheduler_schedule.cartographer-etl-omm-load.name
}

output "sp_etl_Schedule" {
  value = aws_scheduler_schedule.cartographer-etl-sp-load.name
}
