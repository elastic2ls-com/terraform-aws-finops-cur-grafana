# queries #
resource "aws_athena_named_query" "ebs_cost_by_volumetype" {
  name        = "cur_monthly_cost_by_service"
  database    = aws_glue_catalog_database.cur_catalog.name
  description = "Summarizes monthly costs by service type"

  query = <<QUERY
  CREATE OR REPLACE VIEW cur_monthly_cost_by_service AS
SELECT
  product_product_name AS service,
  SUM(line_item_unblended_cost) AS cost,
  date_trunc('month', CAST(usage_start_date AS date)) AS month
FROM cur_table
GROUP BY 1, 3
ORDER BY 3 DESC, 2 DESC;
QUERY
}

# queries #