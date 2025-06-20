variable "grafana_image" {
  description = "Docker image for Grafana"
  type        = string
  default     = "grafana/grafana:latest"
}

variable "admin_user" {
  description = "Grafana admin username"
  type        = string
  default     = "admin"
}

variable "admin_password" {
  description = "Grafana admin password"
  type        = string
  default     = "admin123"
  sensitive   = true
}

variable "cpu" {
  description = "CPU units for the task (e.g. 256 = 0.25 vCPU)"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory in MiB for the task (e.g. 512 = 0.5 GB)"
  type        = number
  default     = 512
}

variable "container_port" {
  description = "Port exposed by Grafana container"
  type        = number
  default     = 3000
}

variable "log_group_name" {
  description = "CloudWatch log group for Grafana logs"
  type        = string
  default     = "/ecs/grafana"
}

variable "execution_role_name" {
  description = "IAM role name for ECS task execution"
  type        = string
  default     = "ecsTaskExecutionRole"
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

variable "project_name" {
  type    = string
  default = "FinOPS-reporting"
}