variable "ami" {
  description = "AMI for EC2 instances"
}

variable "instance_type" {
  description = "Instance type for Ec2 instance"
}

variable "vpc_id" {
  description = "VPC CIDR"
}

variable "public_subneta_id" {
  description = "CIDR for Public Subnet a"
}

variable "public_subnetb_id" {
  description = "CIDR for Public Subnet b"
}

variable "private_subneta_id" {
  description = "CIDR for Private Subnet a"
}

variable "private_subnetb_id" {
  description = "CIDR for Private Subnet b"
}
variable "ec2_profile" {
  description = "CIDR for Private Subnet b"
}