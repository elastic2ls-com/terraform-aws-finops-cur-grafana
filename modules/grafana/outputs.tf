output "task_definition_arn" {
  description = "ARN of the Grafana ECS task definition"
  value       = aws_ecs_task_definition.grafana.arn
}

output "execution_role_arn" {
  description = "ARN of the ECS execution IAM role"
  value       = aws_iam_role.grafana_task_execution.arn
}

output "container_name" {
  description = "Name of the Grafana container in the task definition"
  value       = "grafana"
}

output "container_port" {
  description = "Port exposed by Grafana container"
  value       = var.container_port
}

output "lb_dns_name" {
  value = aws_lb.grafana.dns_name
}