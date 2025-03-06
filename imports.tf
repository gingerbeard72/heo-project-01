# import {
#   to = aws_instance.instance
#   id = "i-0c3d8fad07b436fac"
# }

# import {
#   to = aws_ssm_parameter.cartographer-config
#   id = "heo-cartographer-config"
# }

# import {
#   to = aws_cloudwatch_log_group.cartographer-health-monitor
#   id = "/aws/lambda/cartographer-health-monitoring-lambda"
# }

# import {
#   to = aws_cloudwatch_log_group.cartographer-ipupdater
#   id = "heo/cartographer_ip_updater"
# }

# import {
#   to = aws_cloudwatch_log_metric_filter.general_errors
#   id = "/aws/lambda/cartographer-health-monitoring-lambda:General-Errors"
# }

# import {
#   to = aws_cloudwatch_log_metric_filter.invalid_compressed_data
#   id = "/aws/lambda/cartographer-health-monitoring-lambda:Invalid-Compressed-Data"
# }

# import {
#   to = aws_cloudwatch_log_metric_filter.omm_health_check_failed
#   id = "/aws/lambda/cartographer-health-monitoring-lambda:OMM-Health-Check-Failed"
# }

# import {
#   to = aws_cloudwatch_log_metric_filter.sp_health_check_failed
#   id = "/aws/lambda/cartographer-health-monitoring-lambda:SP-Health-Check-Failed"
# }

# import {
#   to = aws_lambda_function.cartographer-health-monitoring-lambda
#   id = "cartographer-health-monitoring-lambda"
# }

# ## Okapi Imports - DS-368
# import {
#   to = aws_ecr_repository.okapi_lambda
#   id = "cartographer_okapi_etl_lambda_r"
# }

# import {
#   to = aws_cloudwatch_log_group.okapi-etl-lambda
#   id = "/aws/lambda/cartographer-okapi-etl-lambda"
# }
# import {
#   to = aws_iam_role.okapi-etl-lambda-role
#   id = "cartographer-okapi-etl-lambda-role-uccmutv2"
# }

# import {
#   to = aws_secretsmanager_secret.okapi-creds
#   id = "arn:aws:secretsmanager:ap-southeast-2:416663440772:secret:heo_dev/cartographer-okapi-creds-DeQp6W"
# }

# import {
#   to = aws_lambda_function.cartographer-okapi-etl-lambda
#   id = "cartographer-okapi-etl-lambda"
# }

import {
  to = aws_lambda_function.cartographer-spacetrack-etl-lambda
  id = "cartographer-spacetrack-etl-lambda"
}

# import {
#   to       = aws_lambda_function.cartographer-external-ephemeris-etl-lambda
#   id       = "cartographer-external-ephemeris-etl-lambda"
# }

# import {
#   to       = aws_ssm_parameter.cartographer-external-ephemeris-etl-lambda-config
#   id       = "cartographer-external-ephemeris-etl-lambda-config"
# }
