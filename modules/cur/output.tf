output "cur_catalog" {
  value = aws_glue_catalog_database.cur_catalog.name
}

output "athena_workgroup" {
  value = aws_athena_workgroup.cur.name
}
output "athena_result_location" {
  value = "s3://${aws_s3_bucket.cur_bucket.bucket}/athena-results/"
}