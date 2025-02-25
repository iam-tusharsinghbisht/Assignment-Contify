provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr
  public_subneta_cidr = var.public_subneta_cidr
  public_subnetb_cidr = var.public_subnetb_cidr
  private_subneta_cidr = var.private_subneta_cidr
  private_subnetb_cidr = var.private_subnetb_cidr
}

module "iam" {
  source = "./modules/iam"
}

module "s3" {
  source = "./modules/s3"
}

module "ec2" {
  source = "./modules/ec2"

  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_id = module.vpc.vpc_id
  public_subneta_id = module.vpc.public_subenta_id
  public_subnetb_id = module.vpc.public_subentb_id
  private_subneta_id = module.vpc.private_subenta_id
  private_subnetb_id = module.vpc.private_subentb_id
  ec2_profile = module.iam.ec2_profile
}

module "rds" {
  source = "./modules/rds"

  vpc_id = module.vpc.vpc_id
  private_subneta_id = module.vpc.private_subenta_id
  private_subnetb_id = module.vpc.private_subentb_id
  db_name = var.db_name
  db_user = var.db_user
  db_password = var.db_password
}