variable "key_name" {
  description = "SSH key pair name"
  type        = string
}


# Security Groups
resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "cicd-sg" {
  name_prefix = "cicd-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_sg" {
  name_prefix = "app-"

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.cicd-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  name_prefix = "db-"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALB
resource "aws_lb" "app_alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [var.public_subneta_id, var.public_subnetb_id]
}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = var.vpc_id  
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# Auto Scaling Group
resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-"
  image_id      = var.ami  
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    security_groups = [aws_security_group.app_sg.id]
  }

  iam_instance_profile {
    name = var.ec2_profile
  }

  monitoring {
    enabled = true
  }

  user_data = base64encode(file("/modules/ec2/userdata.sh"))

}

resource "aws_autoscaling_group" "app_asg" {
  desired_capacity     = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [var.public_subneta_id, var.public_subnetb_id]
  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }
}

# EC2 Instances
resource "aws_instance" "db" {
  ami           = var.ami  
  instance_type = var.instance_type
  subnet_id    = var.private_subneta_id  
  security_groups = [aws_security_group.db_sg.id]
  key_name      = var.key_name

  iam_instance_profile = var.ec2_profile

  monitoring = true

  user_data = base64encode(file("/modules/ec2/userdatadb.sh"))

  tags = {
    Name = "PostgreSQL-DB"
  }
}

resource "aws_instance" "cicd" {
  ami           = var.ami 
  instance_type = var.instance_type
  subnet_id     = var.private_subnetb_id 
  security_groups = [aws_security_group.cicd-sg.id]
  key_name      = var.key_name

  iam_instance_profile = var.ec2_profile

  monitoring = true

  user_data = base64encode(file("/modules/ec2/userdatacicd.sh"))

  tags = {
    Name = "CI/CD"
  }
}

output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}
