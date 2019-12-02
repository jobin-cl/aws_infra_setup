# aws_infra_setup
Setup core AWS infrastructure using terraform

# eks-cluster-setup-preexisting-vpc
This code can be used to setup a new eks cluster within a pre exiting VPC. The parameters needed to use this module are listed below

- This input value sets a tag that be used to uniquely identify billing responsible party for the assets being built.
  -billto = "FM"

- This input value sets the name of the kubernetes cluster 
  - cluster-name = "test-eks-cluster"

- This input value provides the ami id to use to build the EC2 instances
  - instance-ami = "ami-0c5204531f799e0c6"

- This input value sets the size of the EC2 instance
  - instance_type = "t2.micro"

- This input value sets the key for ssh into the EC2 instances
  - key = "atb"

- This input value sets the AWS region to be used for the build out
  - region = "us-west-2"

- This input value sets the name of the server in your kubernetes cluster
  - server-name = "test-eks-cluster-server"

# eks-vpc-cluster-setup
This code can be used to setup a new eks cluster with networking in a new VPC. The parameters needed to use this module are listed below
- This input value sets a tag that be used to uniquely identify billing responsible party for the assets being built.
  - billto = "FM"

- This input value sets the name of the kubernetes cluster 
  - cluster-name = "test-eks-cluster"

- This input value provides the ami id to use to build the EC2 instances
  - instance-ami = "ami-0c5204531f799e0c6"

- This input value sets the size of the EC2 instance
  - instance_type = "t2.micro"

- This input value sets the key for ssh into the EC2 instances
  - key = "atb"

- This input value sets the AWS region to be used for the build out
  - region = "us-west-2"

- This input value sets the name of the server in your kubernetes cluster
  - server-name = "test-eks-cluster-server"

- This input value sets the name for your VPC being built
  - vpc_name = "test-vpc" 

- This input value sets the CIDR block for the VPC
  - vpc_cidr = "10.0.0.0/16"

- This input value sets the CIDR block for the public subnets in multiple AZs
  - public_subnet_cidr = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]

- This input value sets the CIDR block for the private subnets in multiple AZs
  - private_subnet_cidr = ["10.0.144.0/20", "10.0.160.0/20", "10.0.176.0/20"]


# vpc-public-private-nat-subnet
This code can be used to setup a brand new VPC with public, private subnets and a NAT Gateway. The parameters needed to use this module are listed below
- This input value sets a tag that be used to uniquely identify billing responsible party for the assets being built.
  - billto = "FM"

- This input value sets the name for your VPC being built
  - vpc_name = "test-vpc" 

- This input value sets the CIDR block for the VPC
  - cidr = "10.0.0.0/16"

- This input value sets the CIDR block for the public subnets in multiple AZs
  - public_subnet_cidr = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]

- This input value sets the CIDR block for the private subnets in multiple AZs
  - private_subnet_cidr = ["10.0.144.0/20", "10.0.160.0/20", "10.0.176.0/20"]

- This input value sets the AWS region to be used for the build out
  - aws_region = "us-west-2"

# vpc-public-subnet
This code can be used to setup a VPC with public subnets. The parameters needed to use this module are listed below
- This input value sets a tag that be used to uniquely identify billing responsible party for the assets being built.
  - billto = "FM"

- This input value sets the name for your VPC being built
  - aws_vpc_name = "test-vpc" 

- This input value sets the CIDR block for the VPC
  - vpc_cidr = "10.0.0.0/16"

- This input value sets the CIDR block for the public AZ1
  - public_cidr_zone1 = "10.0.0.0/24"

- This input value sets the CIDR block for the public AZ2
  - public_cidr_zone2 = "10.0.1.0/24"

- This input value sets the AWS region to be used for the build out
  - aws_region = "us-west-2"
