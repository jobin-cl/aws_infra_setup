#
# Variables Configuration
#
variable "cluster-name" {
    description = "Name of the EKS Cluster"
}

variable "vpc_id" {
  description = "need actual VPC ID.. not name"
}

variable "eks_subnets" {
  description = "Master subnet ids"
  type        = "list"
}

variable "worker_subnet" {
  type = "list"
}

variable "subnet_ids" {
  type        = "list"
  description = "List of all subnet in cluster"
}

variable "kubernetes-server-instance-sg" {
  description = "Kubenetes control server security group"
}

variable billto {
  description = "Who should be charged with this spend?"
#  default = "ATB"
}
