variable "region" {
  description = "Provide the region where this infrastrcuture should be created. aka us-east-1, us-west-1."
}

variable billto {
  description = "Who should be charged with this spend?"
#  default = "ATB"
}

variable vpc_name {
  description = "Provide a name for your VPC"
#  default = "eks-vpc-name"
}

variable "vpc_id" {
  description = "What is your VPC id?"
#  default ="vpc-0bac98ee2f0ec1a7c"
}

variable "cluster-name" {
  description = "Name your EKS cluster"
#  default = "eks-cluster"
}

variable "server-name" {
  description = "Name for your server"
#  default = "eks-cluster-server"
}

variable "instance-ami" {
  description = "AMI ID for the base image to use for creation of new instances"
#  default = "ami-0c5204531f799e0c6"
}

variable "instance_type" {
  description = "Size your instance.. t2.micro, t2.medium.."
#  default = "t2.micro"
}

variable "key" {
  description = "key to login to the server"
#  default = "atb"
}

variable "sub_ids" {
  default = []
}
