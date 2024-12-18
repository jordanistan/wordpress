variable "aws_region" {
  default = "us-east-1"
}

variable "db_username" {}
variable "db_password" {}
variable "db_name" {}
variable "ec2_key_name" {}
variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "instance_type" {}
variable "ami_id" {}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "wordpress_vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "wordpress_subnet" {
  vpc_id                  = aws_vpc.wordpress_vpc.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true
}

resource "aws_security_group" "wordpress_sg" {
  vpc_id = aws_vpc.wordpress_vpc.id

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

resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.wordpress_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "wordpress" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.ec2_key_name
  subnet_id     = aws_subnet.wordpress_subnet.id
  security_groups = [aws_security_group.wordpress_sg.name]

  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd php php-mysqlnd
                systemctl start httpd
                systemctl enable httpd
                curl -O https://wordpress.org/latest.tar.gz
                tar -xzf latest.tar.gz
                mv wordpress/* /var/www/html/
                chmod -R 755 /var/www/html/
                chown -R apache:apache /var/www/html/
                EOF
}

resource "aws_rds_instance" "wordpress_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  name                 = var.db_name
  username             = var.db_username
  password             = var.db_password
  publicly_accessible  = false
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  subnet_ids = [aws_subnet.wordpress_subnet.id]
}

resource "aws_s3_bucket" "wordpress_static" {
  bucket = "wordpress-static-assets"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

output "wordpress_instance_ip" {
  value = aws_instance.wordpress.public_ip
}

output "rds_endpoint" {
  value = aws_rds_instance.wordpress_db.endpoint
}
