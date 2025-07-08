#cur report#
resource "aws_cur_report_definition" "cur_report" {
  report_name                = var.cur_report_name
  time_unit                  = var.cur_report_time_unit
  format                     = var.cur_report_format
  compression                = var.cur_report_compression
  additional_schema_elements = ["RESOURCES"]

  s3_bucket = aws_s3_bucket.cur_bucket.id
  s3_region = var.aws_region
  s3_prefix = var.cur_report_prefix

  report_versioning = var.cur_report_versioning

  depends_on = [
    aws_s3_bucket_policy.cur_bucket_policy
  ]
}

resource "aws_s3_bucket" "cur_bucket" {
  bucket = var.cur_s3_bucket_name
}

resource "aws_s3_bucket_policy" "cur_bucket_policy" {
  bucket = aws_s3_bucket.cur_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid    = "AWSBillingPermissions"
      Effect = "Allow"
      Principal = {
        Service = "billingreports.amazonaws.com"
      }
      Action   = "s3:GetBucketAcl"
      Resource = aws_s3_bucket.cur_bucket.arn
      },
      {
        Sid    = "AWSBillingPutObject"
        Effect = "Allow"
        Principal = {
          Service = "billingreports.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cur_bucket.arn}/*"
    }]
  })
}

resource "aws_s3_bucket_public_access_block" "cur_public_access_block" {

  bucket = aws_s3_bucket.cur_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
#glue/ athena#
resource "aws_glue_catalog_database" "cur_catalog" {
  name = var.project_name
}
resource "aws_iam_role" "cur_glue_crawler_role" {
  name = "${var.project_name}-glue-crawler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "glue.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "glue_crawler_policy" {
  role = aws_iam_role.cur_glue_crawler_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:GetObject", "s3:ListBucket"],
        Resource = [
          aws_s3_bucket.cur_bucket.arn,
          "${aws_s3_bucket.cur_bucket.arn}/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = ["glue:*"],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_glue_crawler" "cur_crawler" {
  name          = "${var.project_name}-cur-crawler"
  role          = aws_iam_role.cur_glue_crawler_role.arn
  database_name = aws_glue_catalog_database.cur_catalog.name

  s3_target {
    path = "s3://${aws_s3_bucket.cur_bucket.bucket}/${var.cur_report_prefix}"
  }

  schedule = "cron(0 2 * * ? *)"
}

resource "aws_athena_workgroup" "cur" {
  name = "${var.project_name}-cur-workgroup"

  configuration {
    enforce_workgroup_configuration = true
    result_configuration {
      output_location = "s3://${aws_s3_bucket.cur_bucket.bucket}/athena-results/"
    }
  }
}
#glue/ athena#

