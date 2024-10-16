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
  /*provisioner "local-exec" {
    command = <<EOT
      echo '[private_servers]' > ./inventory && \
      echo '${self.private_ip}' >> ./inventory
    EOT
  }*/
}
# Private EC2 Instance in AZ2
resource "aws_instance" "private_instance_az2" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_az2.id
  key_name      = "tera"
  security_groups = [aws_security_group.private_sg.id]

  tags = {
    Name = "private-instance-az2"
  }
  /*provisioner "local-exec" {
    command = <<EOT
      echo '${self.private_ip}' >> ./inventory && \
      if ! grep -q '[private_servers:vars]' ./inventory; then \
        echo '[private_servers:vars]' >> ./inventory && \
        echo 'ansible_user=ubuntu' >> ./inventory; \
      fi
    EOT
  }*/
}


# Private IPs 
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory"
  content = <<EOT
  [private_servers]
  ${aws_instance.private_instance_az1.private_ip} 
  ${aws_instance.private_instance_az2.private_ip}
  
  [private_servers:vars]
  ansible_user=ubuntu
  EOT

}
