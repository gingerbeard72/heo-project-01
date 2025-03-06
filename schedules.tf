# __generated__ by Terraform from "default/cartographer-etl-sp-load"
resource "aws_scheduler_schedule" "cartographer-etl-sp-load" {
  provider                     = aws.prod
  description                  = "Fetch latest SP data from Space-Track."
  group_name                   = "default"
  name                         = "cartographer-etl-sp-load"
  schedule_expression          = "cron(30,00 * * * ? *)"
  schedule_expression_timezone = "UTC"
  state                        = "ENABLED"
  flexible_time_window {
    maximum_window_in_minutes = 10
    mode                      = "FLEXIBLE"
  }
  target {
    arn      = var.schedule_lambda
    input    = "{ \"StatePayload\": { \"action\": \"trigger_sp_update\" } }"
    role_arn = aws_iam_role.scheduler.arn
    retry_policy {
      maximum_event_age_in_seconds = 86400
      maximum_retry_attempts       = 0
    }
  }
}

# __generated__ by Terraform from "default/cartographer-etl-astroscale-load"
resource "aws_scheduler_schedule" "cartographer-etl-astroscale-load" {
  provider                     = aws.prod
  description                  = "Load latest Astroscale data from Space-Track."
  group_name                   = "default"
  name                         = "cartographer-etl-astroscale-load"
  schedule_expression          = "rate(6 hours)"
  schedule_expression_timezone = "Australia/Sydney"
  state                        = "DISABLED"
  flexible_time_window {
    maximum_window_in_minutes = 5
    mode                      = "FLEXIBLE"
  }
  target {
    arn      = var.schedule_lambda
    input    = "{\n  \"StatePayload\": {\n    \"action\": \"trigger_operator_update\",\n    \"operator\": \"Astroscale\"\n  }\n}"
    role_arn = aws_iam_role.scheduler.arn
    retry_policy {
      maximum_event_age_in_seconds = 86400
      maximum_retry_attempts       = 0
    }
  }
}

# __generated__ by Terraform from "default/cartographer-etl-omm-load"
resource "aws_scheduler_schedule" "cartographer-etl-omm-load" {
  provider                     = aws.prod
  description                  = "Fetch the lastest batch of OMMs into Cartographer using cartographer-spacetrack-etl-lambda."
  group_name                   = "default"
  name                         = "cartographer-etl-omm-load"
  schedule_expression          = "cron(30 4/6 * * ? *)"
  schedule_expression_timezone = "Australia/Sydney"
  state                        = "ENABLED"
  flexible_time_window {
    maximum_window_in_minutes = 10
    mode                      = "FLEXIBLE"
  }
  target {
    arn      = var.schedule_lambda
    input    = "{\n  \"StatePayload\": {\n    \"action\": \"trigger_omm_update\"\n  }\n}"
    role_arn = aws_iam_role.scheduler.arn
    retry_policy {
      maximum_event_age_in_seconds = 86400
      maximum_retry_attempts       = 0
    }
  }
}

resource "aws_scheduler_schedule" "cartographer-okapi-etl" {
  provider                     = aws.prod
  description                  = "Schedule to trigger cartographer-okapi-etl-lambda"
  group_name                   = "default"
  name                         = "cartographer-okapi-etl-lambda"
  schedule_expression          = "cron(10 */6 * * ? *)"
  schedule_expression_timezone = "Australia/Sydney"
  state                        = "ENABLED"
  flexible_time_window {
    maximum_window_in_minutes = 10
    mode                      = "FLEXIBLE"
  }
  target {
    arn      = aws_lambda_function.cartographer-okapi-etl-lambda.arn
    role_arn = aws_iam_role.scheduler.arn
    retry_policy {
      maximum_event_age_in_seconds = 86400
      maximum_retry_attempts       = 185
    }
  }
}

resource "aws_scheduler_schedule" "cartographer-health-monitoring" {
  provider                     = aws.prod
  description                  = "Schedule to trigger cartographer-health-monitoring-lambda"
  group_name                   = "default"
  name                         = "cartographer-health-monitoring-lambda"
  schedule_expression          = "rate(15 minutes)"
  schedule_expression_timezone = "Australia/Sydney"
  state                        = "ENABLED"
  flexible_time_window {
    maximum_window_in_minutes = 10
    mode                      = "FLEXIBLE"
  }

  target {
    arn      = aws_lambda_function.cartographer-health-monitoring-lambda.arn
    role_arn = aws_iam_role.scheduler.arn
    retry_policy {
      maximum_event_age_in_seconds = 600
      maximum_retry_attempts       = 3
    }
  }
}

resource "aws_scheduler_schedule" "cartographer-etl-starlink-load" {
  provider                     = aws.prod
  description                  = "Schedule to trigger cartographer-etl-starlink-load"
  group_name                   = "default"
  name                         = "cartographer-etl-starlink-load"
  schedule_expression          = "cron(45 05,13,21 * * ? *)"
  schedule_expression_timezone = "UTC"
  state                        = "ENABLED"
  flexible_time_window {
    maximum_window_in_minutes = 10
    mode                      = "FLEXIBLE"
  }
  target {
    arn      = data.aws_lambda_function.cartographer-spacetrack-etl-lambda.arn
    role_arn = aws_iam_role.scheduler.arn
    input    = file("./starlink-input.json")
    retry_policy {
      maximum_event_age_in_seconds = 86400
      maximum_retry_attempts       = 3
    }
  }
}

#
resource "aws_scheduler_schedule" "cartographer-etl-blacksky-load" {
  provider                     = aws.prod
  description                  = "Schedule to trigger cartographer-spacetrack-etl-lambda for the Blacksky data load"
  group_name                   = "default"
  name                         = "cartographer-etl-blacksky-load"
  schedule_expression          = "rate(6 hours)"
  schedule_expression_timezone = "Australia/Sydney"
  state                        = "DISABLED"
  flexible_time_window {
    maximum_window_in_minutes = 10
    mode                      = "FLEXIBLE"
  }
  target {
    arn      = data.aws_lambda_function.cartographer-spacetrack-etl-lambda.arn
    role_arn = aws_iam_role.scheduler.arn
    input    = "{\n  \"StatePayload\": {\n    \"action\": \"trigger_operator_update\",\n    \"operator\": \"BlackSky\"\n  }\n}"
    retry_policy {
      maximum_event_age_in_seconds = 300
      maximum_retry_attempts       = 3
    }
  }
}

resource "aws_scheduler_schedule" "cartographer_etl_operator_load" {
  provider                     = aws.prod
  description                  = "Schedule to trigger cartographer-spacetrack-etl-lambda for the operator data load"
  group_name                   = "default"
  name                         = "cartographer-etl-operator-load"
  schedule_expression          = "cron(45 3/6 * * ? *)"
  schedule_expression_timezone = "Australia/Sydney"
  state                        = "ENABLED"

  flexible_time_window {
    maximum_window_in_minutes = 10
    mode                      = "FLEXIBLE"
  }

  target {
    arn      = data.aws_lambda_function.cartographer-spacetrack-etl-lambda.arn
    role_arn = aws_iam_role.scheduler.arn
    input = jsonencode({
      StatePayload = {
        action = "trigger_operator_update"
        operator = [
          "BlackSky",
          "Astroscale",
          "ESASentinelsPublic",
          "Amazon",
          "AmazonPublic"
        ]
      }
    })

    retry_policy {
      maximum_event_age_in_seconds = 300
      maximum_retry_attempts       = 3
    }
  }
}
