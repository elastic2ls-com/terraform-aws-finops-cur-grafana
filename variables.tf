#common vars#
variable "project_name" {
  type = string
}

variable "aws_vpc" {
  description = "The id of the VPC"
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "A list of subnet ids."
}

variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
}
#common vars#


variable "use_fake_data" {
  description = "Enable fake/test mode (no AWS resources created)"
  type        = bool
  default     = false
}



variable "cur_s3_bucket_name" {
  description = "Name of the S3 bucket for CUR data (must be globally unique)"
  type        = string
}

variable "cur_report_name" {
  description = "Name of the CUR report"
  type        = string
}

variable "cur_report_prefix" {
  description = "S3 prefix for CUR report output"
  type        = string
}

variable "cur_report_time_unit" {
  description = "frequency of the Cur report"
  type        = string
}

variable "cur_report_compression" {
  description = "compression used for the Cur report"
  type        = string
}

variable "cur_report_format" {
  description = "format used for the Cur report"
  type        = string
}

variable "cur_report_versioning" {
  description = "versioning used for the Cur report"
  type        = string
}

# variable "athena_database_name" {
#   description = "Name of Athena database for CUR data"
#   type        = string
#   default     = var.project_name
# }
#
# variable "report_table_name" {
#   description = "Name of the Glue/Athena table for CUR"
#   type        = string
#   default     = "cur_table"
# }
#
# variable "crawler_name" {
#   description = "Name of the Glue crawler"
#   type        = string
#   default     = var.project_name
# }

# variable "tag_filter_value" {
#   description = "Tag value used to filter for ENV"
#   type        = string
# }

# grafana #
variable "grafana_image" {
  description = "Docker image for Grafana"
  type        = string
}

variable "grafana_admin_user" {
  description = "Grafana admin username"
  type        = string
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
}

variable "grafana_ecs_network_mode" {
  description = "The network mode)"
  type        = string
}

variable "grafana_ecs_cpu" {
  description = "CPU units for the task (e.g. 256 = 0.25 vCPU)"
  type        = number
}

variable "grafana_ecs_memory" {
  description = "Memory in MiB for the task (e.g. 512 = 0.5 GB)"
  type        = number
}

variable "grafana_ecs_container_port" {
  description = "Port exposed by Grafana container"
  type        = number
}

variable "grafana_ecs_log_group_name" {
  description = "CloudWatch log group for Grafana logs"
  type        = string
}

variable "grafana_ecs_execution_role_name" {
  description = "IAM role name for ECS task execution"
  type        = string
}
#
# variable "cur_catalog" {
#   type = string
# }
#
#
# variable "athena_workgroup" {
#   type = string
# }


# grafana #