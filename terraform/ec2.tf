locals {
  localstack_ami = "ami-12345"
}

# EC2 Instances
resource "aws_instance" "ec2" {
  for_each = var.instances
  ami = local.localstack_ami
  instance_type = each.value.instance_type
  subnet_id = aws_subnet.public.id
  tags = {
    Name = "${var.project}-${var.environment}-${each.value.name}" 
  }
}

# Data source to get latest Amazon Linux 2 AMI
#data "aws_ami" "amazon_linux" {
#  most_recent = true
#  owners      = ["amazon"]

#  filter {
#    name   = "name"
#    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#  }
#}

