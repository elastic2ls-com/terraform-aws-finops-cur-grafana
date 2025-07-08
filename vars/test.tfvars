profile      = "staffing-tool-test"
aws_region   = "eu-central-1"
environment  = "dev"
account_id   = "535159664206"
project_name = "terraform-aws-cur-grafana"


cur_report_prefix               = "cur/ebs-report/"
cur_report_time_unit            = "HOURLY"
cur_report_compression          = "GZIP"
cur_report_format               = "textORcsv"
cur_report_versioning           = "CREATE_NEW_REPORT"
cur_report_name                 = "terraform-aws-cur-grafana"
cur_s3_bucket_name              = "terraform-aws-cur-grafana"
grafana_ecs_execution_role_name = "terraform-aws-cur-grafana"

grafana_image              = "grafana/grafana:latest"
grafana_admin_user         = "admin"
grafana_admin_password     = "admin123!"
grafana_ecs_network_mode   = "awsvpc"
grafana_ecs_cpu            = 256
grafana_ecs_memory         = 512
grafana_ecs_container_port = 3000
grafana_ecs_log_group_name = "/ecs/grafana"
