# --- compute/outputs.tf ---

output "three_tier_frontend_web_asg" {
  value = aws_autoscaling_group.three_tier_frontend_web_asg.arn
  description = "The ARN of the frontend web Auto Scaling Group"
}

output "three_tier_backend_app_asg" {
  value = aws_autoscaling_group.three_tier_backend_app_asg.arn
  description = "The ARN of the backend app Auto Scaling Group"
}

