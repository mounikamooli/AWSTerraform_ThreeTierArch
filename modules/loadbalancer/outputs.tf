# --- loadbalancing/outputs.tf --- 

output "three_tier_alb_endpoint" {
  value = aws_alb.three_tier_alb.dns_name
  description = "dns of alb endpoint"
}

output "aws_alb_target_group_name" {
  value = aws_alb_target_group.three_tier_alb_tg_http.name
  description = "name of alb tg"
}

output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.three_tier_alb_tg_http.arn
  description = "ARN of alb tg"
}
