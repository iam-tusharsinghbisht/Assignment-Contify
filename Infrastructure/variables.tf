#---------- VPC modules Variables ----------#
variable "vpc_cidr" {
  description = "VPC CIDR"
}

variable "public_subneta_cidr" {
  description = "CIDR for Public Subnet a"
}

variable "public_subnetb_cidr" {
  description = "CIDR for Public Subnet b"
}

variable "private_subneta_cidr" {
  description = "CIDR for Private Subnet a"
}

variable "private_subnetb_cidr" {
  description = "CIDR for Private Subnet b"
}
#---------- VPC modules Variables ----------#

#---------- EC2 modules Variables ----------#
variable "ami" {
  description = "AMI for EC2 instances"
}
variable "instance_type" {
  description = "AMI for EC2 instances"
}
variable "key_name" {
  description = "AMI for EC2 instances"
}
#---------- EC2 modules Variables ----------#

#---------- RDS modules Variables ----------#
variable "db_name" {
  description = "DB name for RDS instances"
}
variable "db_user" {
  description = "DB user for RDS instances"
}
variable "db_password" {
  description = "DB passowrd for RDS instances"
}
#---------- RDS modules Variables ----------#