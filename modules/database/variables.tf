# --- database/variables.tf ---

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

variable "three-tier-db-subnetgroup_name" {
  type = string
  description = "name of the db subnet group"
}

variable "three_tier_backend_db_tier_sg_id" {
  type = string
  description = "id of security group assisgned to backend db"
}