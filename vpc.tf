
# VPC Configuration
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_id
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}
