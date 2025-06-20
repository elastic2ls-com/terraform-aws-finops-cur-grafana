variable "project_name" {
  type    = string
  default = "FinOPS-reporting"
}

variable "use_fake_data" {
  description = "Enable fake/test mode (no AWS resources created)"
  type        = bool
  default     = false
}

variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "eu-central-1"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for CUR data (must be globally unique)"
  type        = string
}

variable "report_name" {
  description = "Name of the CUR report"
  type        = string
  default     = "ebs-cost-usage-report"
}

variable "report_prefix" {
  description = "S3 prefix for CUR report output"
  type        = string
  default     = "cur/ebs-report/"
}

variable "athena_database_name" {
  description = "Name of Athena database for CUR data"
  type        = string
  default     = "cur_database"
}

variable "report_table_name" {
  description = "Name of the Glue/Athena table for CUR"
  type        = string
  default     = "cur_table"
}

variable "crawler_name" {
  description = "Name of the Glue crawler"
  type        = string
  default     = "cur-crawler"
}

variable "cost_center" {
  description = "Cost center tag for all resources"
  type        = string
  default     = "FinOps"
}

variable "tag_filter_value" {
  description = "Tag value used to filter for ENV"
  type        = string
  default     = "Production"
}

variable "vpc_id" {
  description = "The id of the VPC"
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "A list of subnet ids."
}