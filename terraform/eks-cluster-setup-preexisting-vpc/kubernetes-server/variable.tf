variable "ssh_public_key" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "instance_type" {
  description = "instance type for K8s creation Server - Eg:t2.micro"
}

variable "instance_ami" {
  description = "AMI for Instance"
}

variable "instance_key" {
  description = "Key for k8s Server"
}

variable "server-name" {
  description = "Name of Kub server"
}

variable "k8-subnet" {
  type = ""
}

variable billto {
  description = "Who should be charged with this spend?"
#  default = "ATB"
}

variable "cluster-name" {
  description = "Name your EKS cluster"
#  default = "eks-cluster"
}
