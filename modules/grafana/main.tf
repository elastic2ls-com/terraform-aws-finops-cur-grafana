# --- IAM Role for Fargate Task Execution ---
resource "aws_iam_role" "grafana_task_execution" {
  name = "${var.project_name}-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_policy" {
  role       = aws_iam_role.grafana_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# --- Security Group ---
resource "aws_security_group" "grafana_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow HTTP 3000 access to Grafana"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = var.subnet_ids // muss auf öffentlich gesetzt werden sobald SSL verfübar ist.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- Task Definition ---
resource "aws_ecs_task_definition" "grafana" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.grafana_task_execution.arn

  container_definitions = jsonencode([
    {
      name  = "grafana"
      image = "grafana/grafana-oss:latest"
      portMappings = [{
        containerPort = 3000
        protocol      = "tcp"
      }]
      environment = [
        {
          name  = "GF_SECURITY_ADMIN_PASSWORD"
          value = var.admin_password
        }
      ]
    }
  ])
}



