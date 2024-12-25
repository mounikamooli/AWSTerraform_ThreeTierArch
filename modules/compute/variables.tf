#-----compute/variables.tf----------

variable "key_name" {
  type = string
  description = "aws key pair name"
}

variable "ami_value" {
  type = string
  description = "ami id used for autoscaling groups"
}

variable "instance_type" {
  type = string
  description = "instance type for autoscaling groups "
}

variable "three_tier_bastion_sg" {
  type = string
  description = "The ID of the security group for the bastion host"
}

variable "three_tier_frontend_web_tier_sg" {
  type = string
  description = "The ID of the security group for the web tier instances"
}

variable "three_tier_backend_app_tier_sg" {
  type = string
  description = "The ID of the security group for the web tier instances"
}

variable "three_tier_app_pvtsub" {
  type = list(string)
  description = "the ID's of the app tier private subnets in both az's"
}

variable "three_tier_web_pubsub" {
  type = list(string)
  description = "the ID's of the web tier public subnets in both az's"
}

variable "aws_alb_target_group_name" {
  type = string
  description = "the name of the load balancer target group"
}

variable "aws_alb_target_group_arn" {
  type = string
  description = "the ARN of the load balancer target group"
}

