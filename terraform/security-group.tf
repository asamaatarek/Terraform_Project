# Security Group for Bastion Host
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Anywhere?
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "bastion-sg"
  }
}

# Bastion Host EC2 Instance
resource "aws_instance" "bastion_az1" {
  ami           = "ami-0e86e20dae9224db8"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_az1.id
  key_name      = "tera"  
  security_groups = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "bastion-host-az1"
  }
}

# Bastion Host EC2 Instance for AZ2
resource "aws_instance" "bastion_az2" {
  ami           = "ami-0e86e20dae9224db8"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_az2.id
  key_name      = "tera"  
  security_groups = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "bastion-host-az2"
  }
}

# Security Group for Private Instances
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]  # Only allow SSH from Bastion
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "private-instance-sg"
  }
}
# Private EC2 Instance in AZ1
resource "aws_instance" "private_instance_az1" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_az1.id
  key_name      = "tera"
  security_groups = [aws_security_group.private_sg.id]

  tags = {
    Name = "private-instance-az1"
  }
}

# Private EC2 Instance in AZ1
resource "aws_instance" "private_instance_az2" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_az2.id
  key_name      = "tera"
  security_groups = [aws_security_group.private_sg.id]

  tags = {
    Name = "private-instance-az2"
  }
}
