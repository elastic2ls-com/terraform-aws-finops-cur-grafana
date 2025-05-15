module "cur_athena" {
  source = "../../"

  aws_region           = "eu-central-1"
  s3_bucket_name       = "my-cur-report-bucket"
  report_name          = "ebs-cost-usage-report"
  report_prefix        = "cur/ebs-report/"
  athena_database_name = "cur_database"
  report_table_name    = "cur_table"
  crawler_name         = "cur-crawler"
}