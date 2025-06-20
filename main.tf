module "grafana" {
  source = "./modules/grafana"
  vpc_id = var.vpc_id
  project_name = var.project_name
}

resource "aws_ecs_cluster" "this" {
  name = var.project_name
}

# --- Load Balancer + Target Group ---
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
  vpc_id      = var.vpc_id

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
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana_tg.arn
  }
}

# --- ECS Service ---
resource "aws_ecs_service" "grafana" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = module.grafana.task_definition_arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.grafana_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.grafana_tg.arn
    container_name   = "grafana"
    container_port   = 3000
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
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow ALB to Grafana on port 3000"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
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