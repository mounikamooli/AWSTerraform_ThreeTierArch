###############################################################################################################################
###################################################### Networking #############################################################
###############################################################################################################################

# VPC Configuartion

resource "aws_vpc" "three_tier_vpc" {
  cidr_block = var.three_tier_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "three_tier_vpc"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# internet gateway for project VPC

resource "aws_internet_gateway" "three_tier_igw" {
  vpc_id = aws_vpc.three_tier_vpc.id
  tags = {
    Name = "three_tier_igw"
  }

  lifecycle {
    create_before_destroy = true
  }
}


# Public subnets for web-tier

resource "aws_subnet" "three_tier_web_pubsub" {
  count = length(var.azs) #This will create a number of subnets equal to the number of Availability Zones in var.azs. ie,2
  vpc_id = aws_vpc.three_tier_vpc.id
  cidr_block = var.subnets_cidrs[count.index] # CIDR for the web tier from list
  availability_zone = var.azs[count.index] # az's from the list
  map_public_ip_on_launch = true

  tags = {
  Name = "three_tier_web_pubsub_${substr(var.azs[count.index], -2, 2)}"
}
}  


# Private subnets for app-tier

resource "aws_subnet" "three_tier_app_pvtsub" {
  count = length(var.azs) #This will create a number of subnets equal to the number of Availability Zones in var.azs. ie,2
  vpc_id = aws_vpc.three_tier_vpc.id
  cidr_block = var.subnets_cidrs[count.index + 2] # CIDR for the web tier from list
  availability_zone = var.azs[count.index] # az's from the list
  map_public_ip_on_launch = false

  tags = {
  Name = "three_tier_app_pvtsub_${substr(var.azs[count.index], - 2, 2)}"
}
}


# private subnets for database-tier

resource "aws_subnet" "three_tier_db_pvtsub" {
  count = length(var.azs)
  vpc_id = aws_vpc.three_tier_vpc.id
  cidr_block = var.subnets_cidrs[count.index + 4]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = "false"

  tags = {
    Name = "three_tier_db_pvtsub_${substr(var.azs[count.index], - 2, 2)}"
  }
}

# elastic IP for NAT

resource "aws_eip" "eip_nat" {
  tags = {
    name = "eip_nat"
  }
}

# NAT gateway for project vpc

resource "aws_nat_gateway" "three_tier_nat" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id = aws_subnet.three_tier_web_pubsub[0].id
  tags = {
    Name = "three_tier_nat"
  }

  depends_on = [ aws_internet_gateway.three_tier_igw ]
}

# public route table

resource "aws_route_table" "three_tier_public_rt" {
  vpc_id = aws_vpc.three_tier_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.three_tier_igw.id
  }

  tags = {
    Name = "three_tier_pub_rt"
  }
}

# private route table

resource "aws_route_table" "three_tier_pvt_rt" {
  vpc_id = aws_vpc.three_tier_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.three_tier_nat.id
  }

  tags = {
    Name = "three_tier_pvt_rt" 
  }
}

# route table association for web-tier subnets

resource "aws_route_table_association" "web_route_association" {
  count = length(var.azs)
  subnet_id = aws_subnet.three_tier_web_pubsub[count.index].id
  route_table_id = aws_route_table.three_tier_public_rt.id
}

# route table association for app-tier subnets

 resource "aws_route_table_association" "app_route_association" {
   count = length(var.azs)
   subnet_id = aws_subnet.three_tier_app_pvtsub[count.index].id
   route_table_id = aws_route_table.three_tier_pvt_rt.id
 }

 # route table association for db-tier subnets

 resource "aws_route_table_association" "db_route_association" {
   count = length(var.azs)
   subnet_id = aws_subnet.three_tier_db_pvtsub[count.index].id
   route_table_id = aws_route_table.three_tier_pvt_rt.id
 }

#security groups

#Bastion security group

resource "aws_security_group" "three_tier_bastion_sg" {
  name = "bastion-sg"
  description = "allow ssh access from internet"
  vpc_id = aws_vpc.three_tier_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.access_ip]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 tags = {
    name = "bastion-sg"
  }
}

# ALB SG

resource "aws_security_group" "three_tier_alb_sg" {
  description = "security group allows http and https from internet"
  name = "three-tier-alb-sg"
  vpc_id = aws_vpc.three_tier_vpc.id

  ingress {
    description = "allow http access from internet"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow all outbound rules"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "three_tier_alb_sg"
  }

}

# frontend web tier sg

resource "aws_security_group" "three_tier_frontend_web_tier_sg" {
  description = "allow http inbound from loadbalancer sg and ssh inblund from bastion sg"
  name = "three-tier-frontend-web-sg"
  vpc_id = aws_vpc.three_tier_vpc.id

  ingress {
    description = "allow http inbound from loadbalancer security group"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.three_tier_alb_sg.id]
  }

  ingress {
    description     = "Allow SSH from Bastion host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.three_tier_bastion_sg.id]  # Bastion SG as source
  }

  egress {
    description = "allow all outbound rules"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "three_tier_frontend_web_tier_sg"
  }

}

# backend app tier sg

resource "aws_security_group" "three_tier_backend_app_tier_sg" {
  description = "allow http inbound from frontend_web_sg and ssh inbound from bastion"
  name = "three-tier-backend-app-sg"
  vpc_id = aws_vpc.three_tier_vpc.id
  
  ingress {
    description = "allow all inblund from frontend_web_sg"
    from_port = 0
    to_port = 0
    protocol = "tcp"
    security_groups = [aws_security_group.three_tier_frontend_web_tier_sg.id]
  }

  ingress {
    description = "allow ssh from bastion "
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.three_tier_bastion_sg.id]
  }

  egress {
    description = "allow all outbound rules"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "three_tier_backend_app_tier_sg"
  }
}

# backend(db tier) db sg

resource "aws_security_group" "three_tier_backend_db_tier_sg" {
  description = "allow MySql port inbound from three_tier_backend_app_tier_sg"
  name = "three-tier-backend-db-tier-sg"
  vpc_id = aws_vpc.three_tier_vpc.id

  ingress {
    description = "allow MySql port three_tier_backend_app_tier_sg"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.three_tier_backend_app_tier_sg.id]
  }

  egress {
    description = "allow all outbound rules"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "three_tier_backend_db_tier_sg"
  }

}

#database subnet group

resource "aws_db_subnet_group" "three_tier_db_subnetgroup" {
  name       = "three-tier-rds-subnetgroup"
  subnet_ids = aws_subnet.three_tier_db_pvtsub[*].id

  tags = {
    Name = "three_tier_rds_subnetgroup"
  }
}




#--------- Note: -----------#

# "count.index"
#----------------------------------------#

#count : is a special argument in Terraform that lets you create multiple instances of a resource.
#count.index is a special variable in Terraform that gives you the index of the current instance being created when you're using count to create multiple resources.
#length(var.azs) is getting the number of Availability Zones (AZs) that you define in the var.azs variable (which is a list of AZs). If var.azs contains 2 AZs, then count will be 2, and Terraform will create 2 subnets.
#This will allow the code to automatically create a subnet for each Availability Zone specified in var.azs.

/* tags = {
  Name = "three_tier_web_pubsub_${substr(var.azs[count.index], -2, 2)}"
}*/
#------------------------------------------------------------------------#

/* This is a string interpolation in Terraform, where dynamic values are inserted into a string using the ${} syntax. The goal here is to generate a name like three_tier_web_pubsub_1a for each subnet, dynamically based on the availability zone (var.azs).

1. var.azs
var.azs is a variable that contains a list of availability zones (AZs).
Example: ["us-east-1a", "us-east-1b", "us-east-1c"].
Each AZ has a region prefix (us-east-) followed by a two-character identifier (1a, 1b, 1c).

2. var.azs[count.index]
count.index is the current index of the loop, ranging from 0 to n-1 (based on the count parameter).
var.azs[count.index] accesses the AZ corresponding to the current iteration.
Example (for iteration count.index = 0):

var.azs[0] → "us-east-1a"

3. substr(var.azs[count.index], -2, 2)
substr() function syntax:

substr(string, offset, length)

string: The input string (e.g., "us-east-1a").
offset: The position in the string where extraction begins.
length: The number of characters to extract.
Using substr(var.azs[count.index], -2, 2):

var.azs[count.index]: Current AZ string (e.g., "us-east-1a").
-2: Negative indexing starts from the second-to-last character ('1' in "us-east-1a").
2: Extract two characters starting from the position specified by -2 (result: "1a").

Iteration with count
--------------------------
The count parameter in Terraform creates multiple resources, and count.index represents the current index of the resource being created. The value of count.index changes as Terraform processes each iteration.

#Example Iterations
--Iteration 1: count.index = 0
var.azs[count.index] becomes var.azs[0].
Access the 0th element of the list:
hcl
Copy code
var.azs[0] = "us-east-1a"

--Iteration 2: count.index = 1
var.azs[count.index] becomes var.azs[1].
Access the 1st element of the list:
hcl
Copy code
var.azs[1] = "us-east-1b"

*/

#---------- Not: ------------#
# The expression "cidr_block = var.subnets-cidrs[count.index + 2]" is used to select the CIDR block for the subnet based on the count.index and adjust it by adding 2
#count.index is a special variable in Terraform that gives you the index of the current instance being created when you're using count to create multiple resources.

