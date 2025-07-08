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

# --- Task Definition ---
resource "aws_ecs_task_definition" "grafana" {
  family                   = "${var.project_name}-task"
  network_mode             = var.grafana_ecs_network_mode
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.grafana_ecs_cpu
  memory                   = var.grafana_ecs_memory
  execution_role_arn       = aws_iam_role.grafana_task_execution.arn

  container_definitions = jsonencode([
    {
      name  = var.project_name
      image = var.grafana_image
      portMappings = [{
        containerPort = var.grafana_ecs_container_port
        protocol      = "tcp"
      }]
      environment = [
        {
          name  = "GF_SECURITY_ADMIN_PASSWORD"
          value = var.grafana_admin_password
        },
        {
          name  = "GF_INSTALL_PLUGINS"
          value = "grafana-athena-datasource"
        }
      ]
    }
  ])
}

resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-cluster"
}

# --- Load Balancer + Target Group ---#
resource "aws_lb" "grafana" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.grafana_sg.id]
  subnets            = var.subnet_ids
}

resource "aws_lb_target_group" "grafana_tg" {
  name        = "${var.project_name}-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  aws_vpc     = var.aws_vpc

  health_check {
    path                = "/"
    port                = "3000"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.grafana.arn
  port              = var.grafana_ecs_container_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana_tg.arn
  }
}

# --- ECS Service --- #
resource "aws_ecs_service" "grafana" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.grafana.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.grafana_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.grafana_tg.arn
    container_name   = var.project_name
    container_port   = var.grafana_ecs_container_port
  }
}

# --- DNS (optional) ---
# resource "aws_route53_record" "grafana_dns" {
#   zone_id = var.zone_id
#   name    = var.domain_name
#   type    = "A"
#
#   alias {
#     name                   = aws_lb.grafana.dns_name
#     zone_id                = aws_lb.grafana.zone_id
#     evaluate_target_health = true
#   }
# }

resource "aws_security_group" "grafana_sg" {
  name        = "${var.project_name}-grafana-sg"
  description = "Security Group for Grafana"
  aws_vpc     = var.aws_vpc

  ingress {
    description = "Allow ALB to Grafana on port 3000"
    from_port   = var.grafana_ecs_container_port
    to_port     = 3000
    protocol    = "var.grafana_ecs_container_port"
    cidr_blocks = ["0.0.0.0/0"] # Nur für Tests – später auf ALB Security Group einschränken!
    # security_groups = [var.alb_security_group_id] # Besser: explizite SG, siehe oben
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-grafana-sg"
  }
}
# --- ECS Service --- #

# --- grafana datasource /dashboard --- #
resource "grafana_data_source" "athena" {
  name = "${var.project_name}-datasource"
  type = "grafana-athena-datasource"

  json_data = jsonencode({
    catalog         = "AwsDataCatalog"
    database        = var.cur_databse
    workgroup       = var.athena_workgroup
    region          = var.aws_region
    output_location = var.s3_cur_uri
  })
}

resource "grafana_dashboard" "cost_overview" {
  config_json = file("${path.module}/dashboards/cur-cost-overview.json")
}
# --- grafana datasource /dashboard --- #
resource "grafana_data_source" "athena_cur" {
  name = "Athena CUR"
  type = "grafana-athena-datasource"

  json_data = jsonencode({
    catalog         = "AwsDataCatalog",
    database        = var.cur_catalog,
    workgroup       = var.athena_workgroup,
    region          = var.aws_region,
    output_location = var.athena_result_location
  })
}

resource "grafana_dashboard" "cur_cost_overview" {
  config_json = file("${path.module}/dashboards/grafana_dashboard_cur_cost_overview.json")
  overwrite   = true
  folder      = "AWS CUR"
}