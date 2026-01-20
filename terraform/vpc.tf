resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project}-${var.environment}-vpc"
  }
}

# TODO: Create public subnets
# Requirements:
# - At least 2 subnets in different availability zones
# - Must have map_public_ip_on_launch = true
# - Use cidrsubnet() function or define CIDR blocks manually

# resource "aws_subnet" "public" {
#   # TODO: Implement public subnets
# }

# TODO: Create internet gateway and route table for public subnets
