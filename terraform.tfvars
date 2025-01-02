# aws region for our architecture
aws_region = "us-east-1"

# availability zones
azs = ["us-east-1a" , "us-east-1b"]

#cidr block of vpc
three_tier_vpc_cidr = "10.0.0.0/16"


# list of CIDR blocks for subnets
subnets_cidrs = [
    "10.0.1.0/24", # Web subnet 1a
    "10.0.2.0/24", # Web subnet 1b
    "10.0.3.0/24", # App subnet 1a
    "10.0.4.0/24", # App subnet 1b
    "10.0.5.0/24", # DB subnet 1a
    "10.0.6.0/24"  # DB subnet 1b
  ]

# aws key pair name
key_name = "three_tier_bastion_key"

# ami value
ami_value = "ami-0166fe664262f664c"

# instance type value
instance_type = "t2.micro"

# three tier mysql db username
db_username = "db_admin"

# three tier mysql db password
db_password = "Admin123"

# three tier mysql db engine type
db_engine = "mysql"

# three tier mysql db engine version
db_engine_version = "8.0"

# three tier mysql db instance class(type)
db_instance_class = "db.t3.micro"

# three tier mysql db identifier
db_identifier = "threetierdb"

# access ip for bastion instance
access_ip = "0.0.0.0/0"

# name of the S3 bucket for artifact storage
s3_artifact_bucket = "threetiers3artifact"
