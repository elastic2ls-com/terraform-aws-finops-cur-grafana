# Grafana ECS Task Submodule

This submodule defines the ECS task definition and execution role required to run Grafana in AWS Fargate. It is designed to be used in combination with infrastructure components (like ALB, Route53, ECS service) defined in the parent module.

## Features

- Creates an ECS-compatible task definition for Grafana
- Defines execution role with appropriate permissions
- Configurable CPU, memory, log group and admin credentials
- Outputs task and role ARNs for use in a parent module

## Usage

```hcl
module "grafana" {
  source = "./modules/grafana"

  grafana_image       = "grafana/grafana-oss:latest"
  admin_user          = "admin"
  admin_password      = "changeme123"
  cpu                 = 256
  memory              = 512
  log_group_name      = "/ecs/grafana"
  execution_role_name = "grafana-exec-role"
}
```

## Inputs

| Name                  | Description                              | Type   | Default                |
|-----------------------|------------------------------------------|--------|------------------------|
| `grafana_image`       | Docker image to use                      | string | `grafana/grafana:latest` |
| `admin_user`          | Grafana admin username                   | string | `admin`                |
| `admin_password`      | Grafana admin password                   | string | `admin123`             |
| `cpu`                 | CPU units for ECS task                   | number | 256                    |
| `memory`              | Memory (MiB) for ECS task                | number | 512                    |
| `container_port`      | Port exposed by Grafana container        | number | 3000                   |
| `log_group_name`      | CloudWatch log group name                | string | `/ecs/grafana`         |
| `execution_role_name` | Name of the IAM execution role          | string | `ecsTaskExecutionRole` |

## Outputs

| Name                  | Description                                |
|-----------------------|--------------------------------------------|
| `task_definition_arn` | ARN of the ECS task definition             |
| `execution_role_arn`  | ARN of the execution role                 |
| `container_name`      | Name of the Grafana container              |
| `container_port`      | Port exposed by Grafana                    |

---

> **Note:** This module is intended to be used within a larger Terraform setup. It does not include networking or service-level configuration. See the root module for complete deployment.
