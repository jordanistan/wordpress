variable "aws_region" {
  description = "AWS region to deploy resources"
}

variable "db_username" {
  description = "Database username"
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  sensitive   = true
}

variable "db_name" {
  description = "Name of the database"
}

variable "ec2_key_name" {
  description = "Key name for EC2 instances"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
}

variable "subnet_cidr_block" {
  description = "CIDR block for the subnet"
}

variable "instance_type" {
  description = "EC2 instance type"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
}
