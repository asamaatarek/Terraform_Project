output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet_az1_id" {
  value = aws_subnet.public_subnet_az1.id
}

output "private_subnet_az1_id" {
  value = aws_subnet.private_subnet_az1.id
}

output "public_subnet_az2_id" {
  value = aws_subnet.public_subnet_az2.id
}

output "private_subnet_az2_id" {
  value = aws_subnet.private_subnet_az2.id
}
output "bastion_public_ip_AZ1" {
  value = aws_instance.bastion_az1.public_ip
  description = "Public IP of the Bastion Host"
}
output "bastion_public_ip_AZ2" {
  value = aws_instance.bastion_az2.public_ip
  description = "private IP of the private instence"
}
output "private_ip_az1" {
  value = aws_instance.private_instance_az1.private_ip
  description = "private IP of the private instence"
}
output "private_ip_az2" {
  value = aws_instance.private_instance_az2.private_ip
  description = "private IP of the private instence"
}