###############################################################################################################################################
########################################################## MySQL DB ###########################################################################
###############################################################################################################################################

# three tier mysql db

resource "aws_db_instance" "three_tier_mysql_db" {
  allocated_storage = 10
  engine = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  username = var.db_username
  password = var.db_password
  db_subnet_group_name = var.three-tier-db-subnetgroup_name
  vpc_security_group_ids = [var.three_tier_backend_db_tier_sg_id]
  identifier = var.db_identifier
  skip_final_snapshot = "true"
  tags = {
    Name = "three_tier_mysql_db"
  }

} 