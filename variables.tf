## ECS Service variables
variable "ecs_name" {
  default = "cartographer"
}

variable "container_name" {
  default = "cartographer-prod"
}
variable "container_port" {
  default = "80"
}

variable "host_port" {
  default = "4305"
}
variable "ecr_image" {
  default = "048955030943.dkr.ecr.ap-southeast-2.amazonaws.com/cartographer_r"
}

variable "postgres_name" {
  default     = "postgres"
  type        = string
  description = "Cartographer postgres database container"
}

variable "postgres_port" {
  default = "5432"
}

## Tags
variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    "heo:env:service" = "prod:Cartographer",
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
  default     = "HEO-prod-Infrastructure"
}

variable "service_discovery" {
  default = "heo-inspect-cluster"
}

variable "instance_type" {
  type    = string
  default = "c7i.xlarge"
}

variable "health_monitor_lambda" {
  description = "Health Monitor Lambda"
  default     = "cartographer-health-monitoring-lambda"
  type        = string
}

variable "health_monitor_lambda_uri" {
  description = "location of lambda image"
  default     = "dkr.ecr.ap-southeast-2.amazonaws.com/cartographer_health_monitoring_lambda_r:latest"
  type        = string
}

variable "environment" {
  default     = "prod"
  description = "the environment to deploy into"
  type        = string

}

variable "schedule_lambda" {
  default     = "arn:aws:lambda:ap-southeast-2:048955030943:function:cartographer-spacetrack-etl-lambda"
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
        "arn:aws:lambda:ap-southeast-2:048955030943:function:cartographer-general-errors-custom-notification"
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


variable "cartographer-okapi-etl-lambda" {
  default = "cartographer-okapi-etl-lambda"
}

variable "cw_metric_filter_pattern" {
  default = "?ERROR ?Error ?error"
}
