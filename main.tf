module "grafana" {
  source       = "./modules/grafana"
  aws_region   = var.aws_region
  aws_vpc      = var.aws_vpc
  subnet_ids   = var.subnet_ids
  project_name = var.project_name

  grafana_image                   = var.grafana_image
  grafana_admin_user              = var.grafana_admin_user
  grafana_admin_password          = var.grafana_admin_password
  grafana_ecs_network_mode        = var.grafana_ecs_network_mode
  grafana_ecs_cpu                 = var.grafana_ecs_cpu
  grafana_ecs_memory              = var.grafana_ecs_memory
  grafana_ecs_container_port      = var.grafana_ecs_container_port
  grafana_ecs_log_group_name      = var.grafana_ecs_log_group_name
  grafana_ecs_execution_role_name = var.grafana_ecs_execution_role_name

  cur_catalog            = module.cur.cur_catalog
  athena_result_location = module.cur.athena_result_location
  athena_workgroup       = module.cur.athena_workgroup
}

module "cur" {
  source       = "./modules/cur"
  aws_region   = var.aws_region
  aws_vpc      = var.aws_vpc
  subnet_ids   = var.subnet_ids
  project_name = var.project_name

  cur_report_compression = var.cur_report_compression
  cur_report_format      = var.cur_report_format
  cur_report_versioning  = var.cur_report_versioning

  cur_report_name      = var.cur_report_name
  cur_s3_bucket_name   = var.cur_s3_bucket_name
  cur_report_prefix    = var.cur_report_prefix
  cur_report_time_unit = var.cur_report_time_unit
}