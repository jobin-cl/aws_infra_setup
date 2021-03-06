#VPC
#variable "create_vpc" {
#  default = ""
#}

variable billto {
  description = "Who should be charged with this spend?"
#  default = "ATB"
}

variable "cluster-name" {
  description = "Cluster name"
}

variable "vpc_name" {}

variable "cidr" {
  description = "The CIDR block for the VPC."
}

#subnet variable
variable "master_subnet_cidr" {
  type        = "list"
  description = "CIDR for master subnet"
  default     = []
}

variable "worker_subnet_cidr" {
  type        = "list"
  description = "CIDR for worker subnet"
  default     = []
}

variable "public_subnet_cidr" {
  description = "Kubernetes Public CIDR"
  type        = "list"
}

variable "private_subnet_cidr" {
  type        = "list"
  description = "Kubernetes Private CIDR"
  default     = []
}
