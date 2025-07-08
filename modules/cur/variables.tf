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
  description = "A list of subnet ids."
}

variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
}
#common vars#

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
#   default     = "cur_catalog"
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
#   default     = "cur-crawler"
# }
#
# variable "cost_center" {
#   description = "Cost center tag for all resources"
#   type        = string
#   default     = "FinOps"
# }
#
# variable "tag_filter_value" {
#   description = "Tag value used to filter for ENV"
#   type        = string
#   default     = "Production"
# }