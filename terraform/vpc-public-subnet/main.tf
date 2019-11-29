# The provider here is aws but it can be other provider
provider "aws" {
  region = "${var.aws_region}"
}

# Create a VPC to launch our instances into
resource "aws_vpc" "create_vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.aws_vpc_name}"
    billto = "${var.billto}"
  }
}

# Create a way out to the internet
resource "aws_internet_gateway" "create_igw" {
  vpc_id = "${aws_vpc.create_vpc.id}"
  tags = {
        Name = "${var.aws_vpc_name}-ig"
        billto = "${var.billto}"
    }
}

# Create the route table
resource "aws_route_table" "create_route_table" {
    vpc_id = "${aws_vpc.create_vpc.id}"

    tags = {
        Name = "${var.aws_vpc_name}-rt"
        billto = "${var.billto}"
    }
}

# Public route as way out to the internet
resource "aws_route" "internet_access" {
# This one can be used for default route table
# route_table_id         = "${aws_vpc.create_vpc.main_route_table_id}"
  route_table_id         = "${aws_route_table.create_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.create_igw.id}"
}


# Create a subnet in the AZ us-east-2a
resource "aws_subnet" "subnet_az1" {
  vpc_id                  = "${aws_vpc.create_vpc.id}"
  cidr_block              = "${var.public_cidr_zone1}"
  map_public_ip_on_launch = true
  availability_zone = "${var.aws_region}a"
  tags = {
  	Name =  "${var.aws_vpc_name}-subnet1"
    billto = "${var.billto}"
  }
}

# Create a subnet in the AZ 
resource "aws_subnet" "subnet_az2" {
  vpc_id                  = "${aws_vpc.create_vpc.id}"
  cidr_block              = "${var.public_cidr_zone2}"
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags = {
  	Name =  "${var.aws_vpc_name}-subnet2"
    billto = "${var.billto}"
  }
}


# Create an Elastic IP
resource "aws_eip" "nat" {
  vpc      = true
  depends_on = ["aws_internet_gateway.create_igw"]
}

# Associate subnet to public route table
resource "aws_route_table_association" "subnet_az1_association" {
    subnet_id = "${aws_subnet.subnet_az1.id}"
    route_table_id = "${aws_route_table.create_route_table.id}"
}

# Associate subnet to public route table
resource "aws_route_table_association" "subnet_az2_association" {
    subnet_id = "${aws_subnet.subnet_az2.id}"
    route_table_id = "${aws_route_table.create_route_table.id}"
}

#NACLs for the VPC
resource "aws_default_network_acl" "default" {
  default_network_acl_id = "${aws_vpc.create_vpc.default_network_acl_id}"

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 210
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 220
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 32768
    to_port    = 65535
  }

   egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 210
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 220
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 32768
    to_port    = 65535
  }
  
  tags = {
    Name = "${var.aws_vpc_name}-nacl"
    billto = "${var.billto}"
  }
}