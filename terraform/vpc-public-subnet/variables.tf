variable "aws_region" {
  description = "AWS region to launch servers."
}

variable "aws_vpc_name" {
  description = "Name your VPC"
}

variable "vpc_cidr" {
  description = "Provide the CIDR block for the VPC,\n Example: 10.0.0.0/16"
}

variable "public_cidr_zone1" {
  description = "Provide the CIDR block for the AZ1,\n Example: 10.0.0.0/24"
}

variable "public_cidr_zone2" {
  description = "Provide the CIDR block for the AZ2,\n Example: 10.0.1.0/24"
}

variable "billto" {
  description = "who should be charged for this buildout?"
}

#variable "access_key" {}
#variable "secret_key" {}
