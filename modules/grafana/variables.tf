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


variable "grafana_image" {
  description = "Docker image for Grafana"
  type        = string
  default     = "grafana/grafana:latest"
}

variable "grafana_admin_user" {
  description = "Grafana admin username"
  type        = string
  default     = "admin"
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  default     = "admin123"
  sensitive   = true
}

variable "grafana_ecs_network_mode" {
  description = "The network mode)"
  type        = string
}

variable "grafana_ecs_cpu" {
  description = "CPU units for the task (e.g. 256 = 0.25 vCPU)"
  type        = number
  default     = 256
}

variable "grafana_ecs_memory" {
  description = "Memory in MiB for the task (e.g. 512 = 0.5 GB)"
  type        = number
  default     = 512
}

variable "grafana_ecs_container_port" {
  description = "Port exposed by Grafana container"
  type        = number
  default     = 3000
}

variable "grafana_ecs_log_group_name" {
  description = "CloudWatch log group for Grafana logs"
  type        = string
  default     = "/ecs/grafana"
}

variable "grafana_ecs_execution_role_name" {
  description = "IAM role name for ECS task execution"
  type        = string
  default     = "ecsTaskExecutionRole"
}

# --- grafana datasource --- #
variable "athena_result_location" {
  type = string
}

variable "cur_catalog" {
  type = string
}

variable "athena_workgroup" {
  type = string
}
# --- grafana datasource --- #