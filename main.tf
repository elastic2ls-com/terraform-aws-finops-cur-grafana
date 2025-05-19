resource "aws_s3_bucket" "cur_bucket" {
  count  = var.use_fake_data ? 0 : 1
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_policy" "cur_bucket_policy" {
  count  = var.use_fake_data ? 0 : 1
  bucket = aws_s3_bucket.cur_bucket[0].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSBillingPermissions",
        Effect    = "Allow",
        Principal = { Service = "billingreports.amazonaws.com" },
        Action    = "s3:GetBucketAcl",
        Resource  = aws_s3_bucket.cur_bucket[0].arn
      },
      {
        Sid       = "AWSBillingPutObject",
        Effect    = "Allow",
        Principal = { Service = "billingreports.amazonaws.com" },
        Action    = "s3:PutObject",
        Resource  = "${aws_s3_bucket.cur_bucket[0].arn}/*"
      }
    ]
  })
}

resource "aws_cur_report_definition" "ebs_report" {
  count                      = var.use_fake_data ? 0 : 1
  report_name                = var.report_name
  time_unit                  = "DAILY"
  format                     = "Parquet"
  compression                = "Parquet"
  additional_schema_elements = ["RESOURCES"]
  s3_bucket                  = var.s3_bucket_name
  s3_region                  = var.aws_region
  s3_prefix                  = var.report_prefix
  report_versioning          = "CREATE_NEW_REPORT"
}

resource "aws_athena_database" "cur_database" {
  count        = var.use_fake_data ? 0 : 1
  name         = var.athena_database_name
  bucket       = var.s3_bucket_name
  comment      = "Athena CUR Database"
}

resource "aws_iam_role" "glue_crawler_role" {
  count = var.use_fake_data ? 0 : 1

  name = "glue-crawler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "glue.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "glue_crawler_policy" {
  count = var.use_fake_data ? 0 : 1
  role  = aws_iam_role.glue_crawler_role[0].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject", "s3:ListBucket"],
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = ["glue:*"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_glue_crawler" "cur_crawler" {
  count        = var.use_fake_data ? 0 : 1
  name         = var.crawler_name
  role         = aws_iam_role.glue_crawler_role[0].arn
  database_name = var.athena_database_name

  s3_target {
    path = "s3://${var.s3_bucket_name}/${var.report_prefix}"
  }
}
