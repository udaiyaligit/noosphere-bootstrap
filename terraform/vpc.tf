resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project}-${var.environment}-vpc"
  }
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/24"
    tags = {
      Name = "${var.project}-${var.environment}-subnet"
    }
 }

 resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
      Name = "${var.project}-${var.environment}-igw"
    }
 }

resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.main.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project}-${var.environment}-publicrt"
  }
}

resource "aws_route_table_association" "prta" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.publicrt.id
}