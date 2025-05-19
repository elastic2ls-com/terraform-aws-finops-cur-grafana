[![Terraform CI](https://github.com/elastic2ls-com/terraform-aws-finops-cur-grafana/actions/workflows/terraform.yml/badge.svg)](https://github.com/elastic2ls-com/terraform-aws-finops-cur-grafana/actions)
![License](https://img.shields.io/badge/license-MIT-brightgreen?logo=mit)
![Status](https://img.shields.io/badge/status-active-brightgreen.svg?logo=git)
[![Sponsor](https://img.shields.io/badge/sponsors-AlexanderWiechert-blue.svg?logo=github-sponsors)](https://github.com/sponsors/AlexanderWiechert/)
[![Contact](https://img.shields.io/badge/website-elastic2ls.com-blue.svg?logo=google-chrome)](https://www.elastic2ls.com/)
[![Terraform Registry](https://img.shields.io/badge/download-blue.svg?logo=terraform&style=social)](https://registry.terraform.io/modules/elastic2ls-com/finops-cur-athena/aws/latest)
![OpenTofu Compatible](https://img.shields.io/badge/OpenTofu-Compatible-4E9A06?logo=opentofu)

# terraform-aws-finops-cur-grafana

Terraform module to automate the setup of AWS Cost and Usage Reports (CUR) and make them queryable in Athena.

Supports:
- CUR report generation (Parquet format)
- Storage in S3 with proper permissions
- Glue Crawler to create Athena table
- Named Athena queries for FinOps reporting

This module is compatible with both Terraform (>=1.4) and OpenTofu (>=1.4).

---

## Features

- Provisions a secure S3 bucket for CUR reports
- Enables daily Parquet-based AWS CUR reports with `RESOURCES` schema
- Automatically registers CUR data via Glue Crawler
- Makes CUR data queryable with Athena
- Creates sample named Athena queries (e.g. EBS cost summary)
- Works seamlessly with Grafana Athena integration
- Example usage included

---

## Usage

### Example

```hcl
module "cur_athena" {
  source = "github.com/elastic2ls-com/terraform-aws-finops-cur-grafana"

  aws_region           = "eu-central-1"
  s3_bucket_name       = "my-cur-report-bucket"
  report_name          = "ebs-cost-usage-report"
  report_prefix        = "cur/ebs-report/"
  athena_database_name = "cur_database"
  report_table_name    = "cur_table"
  crawler_name         = "cur-crawler"
}
```

Then run:

```bash
terraform init
terraform plan
terraform apply
```

---

## Variables

| Name                 | Description                                 | Type   | Default                |
|----------------------|---------------------------------------------|--------|------------------------|
| aws_region           | AWS region                                  | string | "eu-central-1"         |
| s3_bucket_name       | Name of the S3 bucket for CUR data          | string | n/a (required)         |
| report_name          | CUR report name                             | string | "ebs-cost-usage-report"|
| report_prefix        | Prefix in S3 for CUR output                 | string | "cur/ebs-report/"      |
| athena_database_name | Athena database name                        | string | "cur_database"         |
| report_table_name    | Athena table name for CUR data              | string | "cur_table"            |
| crawler_name         | Name of the Glue Crawler                    | string | "cur-crawler"          |

---

## Outputs

| Name                 | Description                             |
|----------------------|-----------------------------------------|
| s3_bucket_name       | Name of the created S3 bucket           |
| athena_database_name | Name of the created Athena database     |
| cur_report_name      | Name of the CUR report created          |
| named_query_id       | ID of the predefined named Athena query |

---

## Requirements

- Terraform ≥ 1.4
- AWS Provider ≥ 5.0

---

## CI/CD

This module includes GitHub Actions to perform:

- `terraform fmt`
- `terraform validate`
- `terraform plan` on examples
- `checkov` security scan

---

## License

MIT

---

## Maintainers

[elastic2ls](https://github.com/elastic2ls-com)
