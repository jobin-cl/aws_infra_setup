# The provider here is aws but it can be other provider
provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

# Create a VPC to launch our instances into
resource "aws_vpc" "training_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "TRAINING-VPC"
  }
}

# Create a way out to the internet
resource "aws_internet_gateway" "training_igw" {
  vpc_id = "${aws_vpc.training_vpc.id}"
  tags {
        Name = "TrainingInternetGateway"
    }
}

# Public route as way out to the internet
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.training_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.training_igw.id}"
}


# Create the training route table
resource "aws_route_table" "training_route_table" {
    vpc_id = "${aws_vpc.training_vpc.id}"

    tags {
        Name = "Training route table"
    }
}

# Create training route
resource "aws_route" "training_route" {
	route_table_id  = "${aws_route_table.training_route_table.id}"
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.nat.id}"
}



# Create a subnet in the AZ us-east-2a
resource "aws_subnet" "subnet_us_east_2a" {
  vpc_id                  = "${aws_vpc.training_vpc.id}"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-2a"
  tags = {
  	Name =  "Subnet az 2a"
  }
}

# Create a subnet in the AZ us-east-2c
resource "aws_subnet" "subnet_us_east_2c" {
  vpc_id                  = "${aws_vpc.training_vpc.id}"
  cidr_block              = "10.0.1.0/24"
  availability_zone = "us-east-2c"
  map_public_ip_on_launch = true
  tags = {
  	Name =  "Subnet az 2c"
  }
}



# Create an EIP for the natgateway
resource "aws_eip" "nat" {
  vpc      = true
  depends_on = ["aws_internet_gateway.training_igw"]
}


# Create a nat gateway and it will depend on the internet gateway creation
resource "aws_nat_gateway" "nat" {
    allocation_id = "${aws_eip.nat.id}"
    subnet_id = "${aws_subnet.subnet_us_east_2a.id}"
    depends_on = ["aws_internet_gateway.training_igw"]
    tags = {
    Name = "TRAINING NAT"
  }

}

# Associate subnet subnet_us_east_2a to public route table
resource "aws_route_table_association" "subnet_us_east_2a_association" {
    subnet_id = "${aws_subnet.subnet_us_east_2a.id}"
    route_table_id = "${aws_vpc.training_vpc.main_route_table_id}"
}

# Associate subnet subnet_us_east_2c to public route table
resource "aws_route_table_association" "subnet_us_east_2c_association" {
    subnet_id = "${aws_subnet.subnet_us_east_2c.id}"
    route_table_id = "${aws_vpc.training_vpc.main_route_table_id}"
}
