resource "aws_subnet" "public_subnet_az1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidr_az1
  map_public_ip_on_launch = true
  availability_zone = var.az1

  tags = {
    Name = "public-subnet-az1"
  }
}

resource "aws_subnet" "private_subnet_az1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr_az1
  availability_zone = var.az1

  tags = {
    Name = "private-subnet-az1"
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidr_az2
  map_public_ip_on_launch = true
  availability_zone = var.az2

  tags = {
    Name = "public-subnet-az2"
  }
}

resource "aws_subnet" "private_subnet_az2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr_az2
  availability_zone = var.az2

  tags = {
    Name = "private-subnet-az2"
  }
}

