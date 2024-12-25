output "load_balancer_endpoint" {
  value = module.loadbalancer.three_tier_alb_endpoint
}

output "db_endpoint" {
  value = module.database.three_tier_mysql_db_endpoint
}