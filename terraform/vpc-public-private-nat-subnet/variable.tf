#VPC
variable billto {
  description = "Who should be charged for this spend?"
}

variable "vpc_name" {
  description = "Name your VPC."
}

variable "cidr" {
  description = "The CIDR block for the VPC.. \n example: 10.0.0.0/16"

}

variable "public_subnet_cidr" {
  description = "Kubernetes Public CIDR.. \n Example: [10.0.204.0/22, 10.0.208.0/22, 10.0.212.0/22]"
  type        = "list"
  default     = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
}

variable "private_subnet_cidr" {
  type        = "list"
  description = "Kubernetes Private CIDR.. \n Example: [10.0.228.0/22, 10.0.232.0/22, 10.0.236.0/22]"
  default     = ["10.0.144.0/20", "10.0.160.0/20", "10.0.176.0/20"]
}
