variable "aws_region" {
  description = "AWS region to deploy the resources"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_az1" {
  description = "CIDR block for the public subnet in AZ1"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_az1" {
  description = "CIDR block for the private subnet in AZ1"
  default     = "10.0.2.0/24"
}

variable "public_subnet_cidr_az2" {
  description = "CIDR block for the public subnet in AZ2"
  default     = "10.0.3.0/24"
}

variable "private_subnet_cidr_az2" {
  description = "CIDR block for the private subnet in AZ2"
  default     = "10.0.4.0/24"
}

variable "ami"{
    description = "AMI"
    default = "ami-0c55b159cbfafe1f0"
}

# variable "IP"{
#     description = "ip"
#     default = "0.0.0.0/0"
# }

variable "instance_type"{
    description = "Instance Type"
    default = "t2.micro"
}

variable "az1" {
  description = "First Availability Zone"
  default     = "us-east-1a"
}

variable "az2" {
  description = "Second Availability Zone"
  default     = "us-east-1b"
}
