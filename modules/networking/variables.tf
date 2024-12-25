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

variable "access_ip" {
  type = string
  description = "specific ip address only permit for ssh into bastion instance"
}