output "wordpress_instance_ip" {
  description = "Public IP address of the WordPress EC2 instance"
  value       = aws_instance.wordpress.public_ip
}

output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_rds_instance.wordpress_db.endpoint
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for static assets"
  value       = aws_s3_bucket.wordpress_static.bucket
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.wordpress_vpc.id
}

output "subnet_id" {
  description = "ID of the created Subnet"
  value       = aws_subnet.wordpress_subnet.id
}

output "wordpress_security_group_id" {
  description = "ID of the WordPress security group"
  value       = aws_security_group.wordpress_sg.id
}

output "rds_security_group_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds_sg.id
}
