## ECS Service variables
variable "ecs_name" {
  default = ""
}

variable "container_name" {
  default = "-prod"
}
variable "container_port" {
  default = "80"
}

variable "host_port" {
  default = "4305"
}
variable "ecr_image" {
  default = "account_id.dkr.ecr.ap-southeast-2.amazonaws.com/_r"
}

variable "postgres_name" {
  default     = ""
  type        = string
  description = " database container"
}

variable "postgres_port" {
  default = ""
}

## Tags
variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    "heo:env:service" = "prod:",
    "creator"         = "terraform"
  }
}

variable "sns_endpoint" {
  description = "sns endpoint for the alert message"
  default     = "https://global.sns-api.chatbot.amazonaws.com"
  type        = string
}

variable "sns_topic_name" {
  description = "Name of SNS Topic"
  default     = "-Infrastructure"
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "health_monitor_lambda" {
  description = "Health Monitor Lambda"
  default     = ""
  type        = string
}

variable "health_monitor_lambda_uri" {
  description = "location of lambda image"
  default     = "dkr.ecr.ap-southeast-2.amazonaws.com/_:latest"
  type        = string
}

variable "environment" {
  default     = "prod"
  description = "the environment to deploy into"
  type        = string

}

variable "schedule_lambda" {
  default     = "arn:aws:lambda:ap-southeast-2::function:--etl-lambda"
  type        = string
  description = "lambda target for the eventbridge targets"
}

# variable "health_monitors" {
#   description = "Tags to set for all resources"
#   type        = map(string)
#   default = {
#     "general-errors"          = "General-Errors",
#     "omm health check failed" = "OMM-Health-Check-Failed",
#     "sp health check failed"  = "SP-Health-Check-Failed",
#     "invalid compressed data" = "Invalid-Compressed-Data"
#   }
# }

variable "health_monitors" {
  description = "Tags to set for all resources"
  type = map(object({
    name          = string
    alarm_actions = list(string)
    }
    )

  )
  default = {
    "general-errors" = {
      name = "General-Errors"
      alarm_actions = [
        "arn:aws:lambda:ap-southeast-2::function:-general-errors-custom-notification"
      ]
    },
    "omm health check failed" = {
      name          = "OMM-Health-Check-Failed"
      alarm_actions = []
    },
    "sp health check failed" = {
      name          = "SP-Health-Check-Failed"
      alarm_actions = []
    },
    "invalid compressed data" = {
      name          = "Invalid-Compressed-Data"
      alarm_actions = []
    }
  }
}


variable "health_monitor_objects" {
  type = map(object({
    name    = string
    pattern = string
    }
    )
  )
  default = {
    "general-errors" = {
      name    = "General-Errors"
      pattern = "?ERROR ?Error ?error"
    },
    "omm_health_check_failed" = {
      name    = "OMM-Health-Check-Failed"
      pattern = "%OMM health check failed%"
    },
    "sp_health_check_failed" = {
      name    = "SP-Health-Check-Failed"
      pattern = "%SP health check failed%"
    },
    "invalid_compressed_data" = {
      name    = "Invalid-Compressed-Data"
      pattern = "%Invalid-Compressed-Data%"
    }
  }
}


variable "--etl-lambda" {
  default = "--etl-lambda"
}

variable "cw_metric_filter_pattern" {
  default = "?ERROR ?Error ?error"
}
