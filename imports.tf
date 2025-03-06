# import {
#   to = aws_instance.instance
#   id = ""
# }

# import {
#   to = aws_ssm_parameter.config
#   id = "config"
# }

# import {
#   to = aws_cloudwatch_log_group.health-monitor
#   id = "/aws/lambda/health-monitoring-lambda"
# }

# import {
#   to = aws_cloudwatch_log_group.ipupdater
#   id = "heo/ip_updater"
# }

# import {
#   to = aws_cloudwatch_log_metric_filter.general_errors
#   id = "/aws/lambda/health-monitoring-lambda:General-Errors"
# }

# import {
#   to = aws_cloudwatch_log_metric_filter.invalid_compressed_data
#   id = "/aws/lambda/health-monitoring-lambda:Invalid-Compressed-Data"
# }

# import {
#   to = aws_cloudwatch_log_metric_filter.omm_health_check_failed
#   id = "/aws/lambda/health-monitoring-lambda:OMM-Health-Check-Failed"
# }

# import {
#   to = aws_cloudwatch_log_metric_filter.sp_health_check_failed
#   id = "/aws/lambda/health-monitoring-lambda:SP-Health-Check-Failed"
# }

# import {
#   to = aws_lambda_function.health-monitoring-lambda
#   id = "health-monitoring-lambda"
# }

# ##  Imports - DS-368
# import {
#   to = aws_ecr_repository._lambda
#   id = "_etl_lambda_r"
# }

# import {
#   to = aws_cloudwatch_log_group.-etl-lambda
#   id = "/aws/lambda/-etl-lambda"
# }
# import {
#   to = aws_iam_role.-etl-lambda-role
#   id = "-etl-lambda-role-"
# }

# import {
#   to = aws_secretsmanager_secret.-creds
#   id = "arn:aws:secretsmanager:ap-southeast-2::secret:heo_dev/"
# }

# import {
#   to = aws_lambda_function.-etl-lambda
#   id = "-etl-lambda"
# }

import {
  to = aws_lambda_function.spacetrack-etl-lambda
  id = "spacetrack-etl-lambda"
}

# import {
#   to       = aws_lambda_function.external-ephemeris-etl-lambda
#   id       = "external-ephemeris-etl-lambda"
# }

# import {
#   to       = aws_ssm_parameter.external-ephemeris-etl-lambda-config
#   id       = "external-ephemeris-etl-lambda-config"
# }
