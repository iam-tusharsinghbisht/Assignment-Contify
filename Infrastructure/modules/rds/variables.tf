variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Storage allocated to RDS instance"
  type        = number
  default     = 20
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subneta_id" {
  description = "ID for Private Subnet a"
  type        = string
}

variable "private_subnetb_id" {
  description = "ID for Private Subnet b"
  type        = string
}

