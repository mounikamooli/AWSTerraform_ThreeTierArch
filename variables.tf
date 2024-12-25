variable "aws_region" {
  type = string
  description = "aws region of our architecture"
}

variable "azs" {
  type = list(string)
  description = "list of availability zones"
}

variable "three_tier_vpc_cidr" {
  type = string
  description = "cidr block of three_tier vpc"
}

variable "subnets_cidrs" {
  type = list(string)
  description = "List of CIDR blocks for subnets (web, app, and db tiers)"
}

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

variable "db_username" {
  type = string
  description = "three tier mysql db username"
}

variable "db_password" {
  type = string
  description = "three tier mysql db password"
}

variable "db_engine" {
  type = string
  description = "three tier mysql db engine type"
}

variable "db_engine_version" {
  type = string
  description = "three tier mysql db engine version"
}

variable "db_instance_class" {
  type = string
  description = "three tier mysql db instance class(type)"
}

variable "db_identifier" {
  type = string
  description = "three tier mysql db identifier"
}

variable "access_ip" {
  type = string
  description = "sepcific ip address only permit for ssh into bastion instance"
}

variable "s3_artifact_bucket" {
  description = "Name of the S3 bucket for artifact storage"
}