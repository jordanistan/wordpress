# Terraform WordPress Setup on AWS

This repository contains Terraform configurations to set up a scalable WordPress website on AWS. The setup includes:

- **Amazon VPC**: Networking resources.
- **Amazon EC2**: Hosting WordPress PHP files and web server.
- **Amazon RDS (MySQL)**: Managed database service for WordPress.
- **Amazon S3**: Storage for static assets like images and media.
- **Security Groups**: Restrict access to instances and the database.

## Prerequisites

1. **Terraform Installed**: Ensure you have [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
2. **AWS Account**: Access to an AWS account.
3. **IAM User with Admin Permissions**: Configure your AWS CLI with an IAM user with sufficient permissions.
4. **Key Pair**: Generate an AWS EC2 key pair for SSH access.

## Project Structure

- `main.tf`: Core Terraform configuration for resources.
- `variables.tf`: Definitions of variables used in the project.
- `outputs.tf`: Outputs to fetch information about the created resources.
- `providers.tf`: Provider configuration for AWS.
- `terraform.tfvars` (or secrets file): Stores sensitive values like database credentials.
- `.gitignore`: Prevents sensitive files from being committed.

## Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Configure Variables**:
   - Create a `terraform.tfvars` file in the root directory with the following:
     ```hcl
     db_username      = "your_database_username"
     db_password      = "your_secure_password"
     db_name          = "your_database_name"
     ec2_key_name     = "your_key_name"
     aws_region       = "your_aws_region"
     vpc_cidr_block   = "10.0.0.0/16"
     subnet_cidr_block = "10.0.1.0/24"
     instance_type    = "t3.small"
     ami_id           = "ami-0c02fb55956c7d316"
     ```

3. **Initialize Terraform**:
   Initialize the Terraform working directory to download necessary provider plugins.
   ```bash
   terraform init
   ```

4. **Plan the Deployment**:
   Review the planned changes to ensure correctness.
   ```bash
   terraform plan
   ```

5. **Apply the Configuration**:
   Deploy the resources on AWS.
   ```bash
   terraform apply
   ```
   Confirm the action when prompted.

6. **Retrieve Outputs**:
   After successful deployment, Terraform will output information such as:
   - Public IP of the WordPress EC2 instance
   - RDS endpoint
   - S3 bucket name

   Example:
   ```
   wordpress_instance_ip = "54.123.45.67"
   rds_endpoint = "mydb.abc123.us-east-1.rds.amazonaws.com"
   ```

7. **Access WordPress**:
   - Visit `http://<wordpress_instance_ip>` in your browser to set up WordPress.
   - Use the RDS endpoint, username, and password during the WordPress installation process.

## What Does Each File Do?

### `main.tf`
Defines the core infrastructure, including the VPC, Subnet, EC2 instance, RDS instance, and S3 bucket.

### `variables.tf`
Contains all variables used in the configuration, making the setup customizable and secure.

### `outputs.tf`
Outputs important resource information after deployment, like instance IP and database endpoint.

### `providers.tf`
Specifies the AWS provider and required Terraform version.

### `terraform.tfvars`
Sensitive values for variables, such as database credentials and AWS configurations. Ensure this file is never committed to version control.

### `.gitignore`
Prevents sensitive files like `*.tfvars` and state files from being tracked in git.

## Clean Up
To destroy the infrastructure and avoid AWS charges:
```bash
terraform destroy
```
Confirm the action when prompted.

## Notes
- Monitor your AWS usage to avoid unexpected charges.
- Use AWS IAM roles and policies to enhance security.

Feel free to reach out if you encounter issues or have questions!
