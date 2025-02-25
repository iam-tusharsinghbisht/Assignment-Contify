
# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["sg-app"]  # Replace with the security group ID of your application server
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [var.private_subneta_id,var.private_subnetb_id]
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "postgres" {
  identifier             = "postgres-db"
  engine                 = "postgres"
  engine_version         = "15.3"
  instance_class         = var.db_instance_class
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  username               = var.db_user
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false
  multi_az               = true
  backup_retention_period = 7
  storage_encrypted      = true
  skip_final_snapshot    = true
  apply_immediately      = true
  deletion_protection    = false
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}
