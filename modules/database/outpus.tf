# --- database/outputs.tf ---

output "three_tier_mysql_db_endpoint" {
  value = aws_db_instance.three_tier_mysql_db.endpoint
  description = "endpoint url for mysql db"
}