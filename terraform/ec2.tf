# EC2 Instances
# TODO: Create 3 EC2 instances with different configurations
# Requirements:
# - Use for_each with var.instances
# - Instances should be placed in public subnets

# Data source to get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# TODO: Create aws_instance resources
# Hint: for_each = var.instances

# TODO: Create security group(s) for the instances
