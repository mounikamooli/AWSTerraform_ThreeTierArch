# --- networking/outputs.tf ---

output "three_tier_alb_sg_id" {
  value = aws_security_group.three_tier_alb_sg.id
  description = "id of alb sg"
}

output "three_tier_vpc_id" {
  value = aws_vpc.three_tier_vpc.id
  description = "id of three tier vpc"
}

output "three-tier-db-subnetgroup_name" {
  value = aws_db_subnet_group.three_tier_db_subnetgroup.name
  description = "name of the db subnet group"
}

output "three-tier-db-subnetgroup_id" {
  value = aws_db_subnet_group.three_tier_db_subnetgroup.id
  description = "id of the db subnet group"
}

output "three_tier_backend_db_tier_sg" {
  value = aws_security_group.three_tier_backend_db_tier_sg.id
  description = "id of the db security group"
}

output "three_tier_bastion_sg" {
  value = aws_security_group.three_tier_bastion_sg.id
  description = "id of the bastion security group"
}

output "three_tier_alb_sg" {
  value = aws_security_group.three_tier_alb_sg.id
  description = "id of the alb security group"
}

output "three_tier_frontend_web_tier_sg" {
  value = aws_security_group.three_tier_frontend_web_tier_sg.id
  description = "id of the web tier security group"
}

output "three_tier_backend_app_tier_sg" {
  value = aws_security_group.three_tier_backend_app_tier_sg.id
  description = "id of the app tier security group"
}

output "three_tier_web_pubsub" {
  value = aws_subnet.three_tier_web_pubsub.*.id
  description = "id's of the public subnets "
}

output "three_tier_app_pvtsub" {
  value = aws_subnet.three_tier_app_pvtsub.*.id
  description = "id's of the private subnets"
}