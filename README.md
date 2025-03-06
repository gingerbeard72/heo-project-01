<!-- BEGIN_TF_DOCS -->
![alt text](HEO_Logo_Blue.png)



## HEO Dev Cartographer Service
Cartographer is a state management service for HEO. It is intended to serve as a
single source of truth for position and state information about relevant space objects.
https://heo.atlassian.net/wiki/spaces/DEV/pages/244908033/Cartographer%3A+HEO+State+Management

![alt text](heo_dev_cartographer_service.png)
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.55.0 |
| <a name="provider_aws.prod"></a> [aws.prod](#provider\_aws.prod) | 5.55.0 |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.55.0 |

## Variables and Data resources in use

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cartographer-okapi-etl-lambda"></a> [cartographer-okapi-etl-lambda](#input\_cartographer-okapi-etl-lambda) | n/a | `string` | `"cartographer-okapi-etl-lambda"` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | n/a | `string` | `"cartographer-prod"` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | n/a | `string` | `"80"` | no |
| <a name="input_cw_metric_filter_pattern"></a> [cw\_metric\_filter\_pattern](#input\_cw\_metric\_filter\_pattern) | n/a | `string` | `"?ERROR ?Error ?error"` | no |
| <a name="input_ecr_image"></a> [ecr\_image](#input\_ecr\_image) | n/a | `string` | `"048955030943.dkr.ecr.ap-southeast-2.amazonaws.com/cartographer_r"` | no |
| <a name="input_ecs_name"></a> [ecs\_name](#input\_ecs\_name) | # ECS Service variables | `string` | `"cartographer"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | the environment to deploy into | `string` | `"prod"` | no |
| <a name="input_health_monitor_lambda"></a> [health\_monitor\_lambda](#input\_health\_monitor\_lambda) | Health Monitor Lambda | `string` | `"cartographer-health-monitoring-lambda"` | no |
| <a name="input_health_monitor_lambda_uri"></a> [health\_monitor\_lambda\_uri](#input\_health\_monitor\_lambda\_uri) | location of lambda image | `string` | `"dkr.ecr.ap-southeast-2.amazonaws.com/cartographer_health_monitoring_lambda_r:latest"` | no |
| <a name="input_health_monitor_objects"></a> [health\_monitor\_objects](#input\_health\_monitor\_objects) | n/a | <pre>map(object({<br>    name    = string<br>    pattern = string<br>    }<br>    )<br>  )</pre> | <pre>{<br>  "general-errors": {<br>    "name": "General-Errors",<br>    "pattern": "?ERROR ?Error ?error"<br>  },<br>  "invalid_compressed_data": {<br>    "name": "Invalid-Compressed-Data",<br>    "pattern": "%Invalid-Compressed-Data%"<br>  },<br>  "omm_health_check_failed": {<br>    "name": "OMM-Health-Check-Failed",<br>    "pattern": "%OMM health check failed%"<br>  },<br>  "sp_health_check_failed": {<br>    "name": "SP-Health-Check-Failed",<br>    "pattern": "%SP health check failed%"<br>  }<br>}</pre> | no |
| <a name="input_health_monitors"></a> [health\_monitors](#input\_health\_monitors) | Tags to set for all resources | `map(string)` | <pre>{<br>  "general-errors": "General-Errors",<br>  "invalid compressed data": "Invalid-Compressed-Data",<br>  "omm health check failed": "OMM-Health-Check-Failed",<br>  "sp health check failed": "SP-Health-Check-Failed"<br>}</pre> | no |
| <a name="input_host_port"></a> [host\_port](#input\_host\_port) | n/a | `string` | `"4305"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"t2.micro"` | no |
| <a name="input_postgres_name"></a> [postgres\_name](#input\_postgres\_name) | Cartographer postgres database container | `string` | `"postgres"` | no |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | n/a | `string` | `"5432"` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | Tags to set for all resources | `map(string)` | <pre>{<br>  "creator": "terraform",<br>  "heo:env:service": "prod:Cartographer"<br>}</pre> | no |
| <a name="input_schedule_lambda"></a> [schedule\_lambda](#input\_schedule\_lambda) | lambda target for the eventbridge targets | `string` | `"arn:aws:lambda:ap-southeast-2:048955030943:function:cartographer-spacetrack-etl-lambda"` | no |
| <a name="input_service_discovery"></a> [service\_discovery](#input\_service\_discovery) | n/a | `string` | `"heo-inspect-cluster"` | no |
| <a name="input_sns_endpoint"></a> [sns\_endpoint](#input\_sns\_endpoint) | sns endpoint for the alert message | `string` | `"https://global.sns-api.chatbot.amazonaws.com"` | no |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | Name of SNS Topic | `string` | `"HEO-prod-Infrastructure"` | no |

## AWS Resources in use

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.cartographer-external-ephemeris-etl-lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.cartographer-health-monitor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.cartographer-ipupdater](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.log-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.okapi-etl-lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_metric_filter.cartographer_fatal_error_filters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.ipupdater_metric_filters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.metric_filters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.okapi_metric_filters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_metric_alarm.cartographer_fatal_error_filter_alarms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_95_cpu_utilization_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ecs_cluster_rocket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ipupdater_metric_filter_alarms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.metric_filter_alarms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.okapi_metric_filter_alarms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_ecr_repository.cartographer-external-ephemeris-etl-lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.cartographer_health_monitoring_lambda_r](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.okapi_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_service.ecs_service_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.ecs_task_definition_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.cartographer-ecs-task-permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.cartographer_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.scheduler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cartographer-ecs-web-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.cartographer-external-ephemeris-etl-lambda-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.cartographer-taskexecution-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.health_monitor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.okapi-etl-lambda-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.scheduler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.Task_run](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.cartographer-external-ephemeris-etl-lambda-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.health_monitor_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.okapi_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cartographer-ecs-task-permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cartographer-external-ephemeris-etl-lambda-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_policy_attachment_AmazonECSTaskExecutionRolePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_policy_attachment_AmazonSSMInstanceCore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_policy_attachment_AmazonSSMReadOnlyAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_policy_attachment_CloudWatchAgentServerPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_policy_attachment_ContainerRegistry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_policy_attachment_s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_policy_attachment_secrets_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_policy_attachment_secretsmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_policy_attachment_web_role_AWSLambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_policy_attachment_web_role_AmazonRDSDataFullAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_policy_attachment_web_role_AmazonSSMFullAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_policy_attachment_web_role_SecretsManager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_policy_attachment_web_role_ask_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_policy_attachment_web_role_task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.scheduler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_lambda_function.cartographer-external-ephemeris-etl-lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.cartographer-health-monitoring-lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.cartographer-okapi-etl-lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_scheduler_schedule.cartographer-etl-astroscale-load](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_scheduler_schedule.cartographer-etl-omm-load](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_scheduler_schedule.cartographer-etl-sp-load](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_scheduler_schedule.cartographer-etl-starlink-load](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_scheduler_schedule.cartographer-health-monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_scheduler_schedule.cartographer-okapi-etl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_sns_topic.cartographer_errors](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_ssm_parameter.cartographer-cartographer_health_monitoring_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.cartographer-config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.cartographer-external-ephemeris-etl-lambda-config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.cartographer-okapi-etl-config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.cartographer-spacetrack-etl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.ecsparameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Output Information

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_Cloudwatch_logs"></a> [Cloudwatch\_logs](#output\_Cloudwatch\_logs) | The Cloudwatch Log group for the Cartographer Service |
| <a name="output_ECS_task_def_app"></a> [ECS\_task\_def\_app](#output\_ECS\_task\_def\_app) | Cartographer App Task definition |
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | n/a |
| <a name="output_astroscale_etl_Schedule"></a> [astroscale\_etl\_Schedule](#output\_astroscale\_etl\_Schedule) | n/a |
| <a name="output_cloudwatch_alarm"></a> [cloudwatch\_alarm](#output\_cloudwatch\_alarm) | Cloudwatch Metric Alarm output |
| <a name="output_ecs_service_app"></a> [ecs\_service\_app](#output\_ecs\_service\_app) | ECS Service information for the Cartographer App Service |
| <a name="output_etl_omm_Schedule"></a> [etl\_omm\_Schedule](#output\_etl\_omm\_Schedule) | n/a |
| <a name="output_instance"></a> [instance](#output\_instance) | Show the public IP of the newly created instance |
| <a name="output_locals"></a> [locals](#output\_locals) | n/a |
| <a name="output_log_metric_filter"></a> [log\_metric\_filter](#output\_log\_metric\_filter) | Cloudwatch Metric Alarm output |
| <a name="output_metric_filter_alarms"></a> [metric\_filter\_alarms](#output\_metric\_filter\_alarms) | Cloudwatch Metric Alarm output |
| <a name="output_okapi_etl_Schedule"></a> [okapi\_etl\_Schedule](#output\_okapi\_etl\_Schedule) | n/a |
| <a name="output_sns_topic"></a> [sns\_topic](#output\_sns\_topic) | n/a |
| <a name="output_sp_etl_Schedule"></a> [sp\_etl\_Schedule](#output\_sp\_etl\_Schedule) | n/a |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | n/a |
| <a name="output_task_role"></a> [task\_role](#output\_task\_role) | Cartographer task execution role |
| <a name="output_web_role"></a> [web\_role](#output\_web\_role) | Cartographer web role |


<!-- END_TF_DOCS -->    