# define s3 remote backend

/*terraform {
  backend "s3" {
    bucket = "threetierremotebackend"
    dynamodb_table = "remotebackend_statelock_dynamodb"
    key = "threetierremotebackend/terraform.tfstate"
    encrypt = true
    region = "us-east-1"
  }
}*/

terraform {
  cloud {
    organization = "CloudAravind"

    workspaces {
      name = "AWSTerraform_ThreeTierArch"
    }
  }
}

module "networking" {
 source = "./modules/networking"
 three_tier_vpc_cidr = var.three_tier_vpc_cidr
 access_ip = var.access_ip
 subnets_cidrs = var.subnets_cidrs
 azs = var.azs

}

module "compute" {
  source = "./modules/compute"
  key_name = var.key_name
  ami_value = var.ami_value
  instance_type = var.instance_type
  three_tier_bastion_sg = module.networking.three_tier_bastion_sg
  three_tier_frontend_web_tier_sg = module.networking.three_tier_frontend_web_tier_sg
  three_tier_backend_app_tier_sg = module.networking.three_tier_backend_app_tier_sg
  three_tier_app_pvtsub = module.networking.three_tier_app_pvtsub
  three_tier_web_pubsub = module.networking.three_tier_web_pubsub
  aws_alb_target_group_arn = module.loadbalancer.aws_alb_target_group_arn
  aws_alb_target_group_name = module.loadbalancer.aws_alb_target_group_name
}

module "loadbalancer" {
  source = "./modules/loadbalancer"
  three_tier_alb_sg = module.networking.three_tier_alb_sg
  three_tier_web_pubsub = module.networking.three_tier_web_pubsub
  three_tier_frontend_web_asg = module.compute.three_tier_frontend_web_asg
  tg_port = 80
  tg_protocol = "HTTP"
  three_tier_vpc_id = module.networking.three_tier_vpc_id
  listener_protocol = "HTTP"
  listener_port = 80
}

output "three_tier_alb_endpoint" {
  value = module.loadbalancer.three_tier_alb_endpoint
}



module "database" {
  source = "./modules/database"
  db_engine = var.db_engine
  db_engine_version = var.db_engine_version
  db_instance_class = var.db_instance_class
  db_username = var.db_username
  db_identifier = var.db_identifier
  db_password = var.db_password
  three-tier-db-subnetgroup_name = module.networking.three-tier-db-subnetgroup_name
  three_tier_backend_db_tier_sg_id = module.networking.three_tier_backend_db_tier_sg
}

module "s3-artifact" {
  source = "./modules/s3-artifact"
  s3_artifact_bucket = var.s3_artifact_bucket
}
