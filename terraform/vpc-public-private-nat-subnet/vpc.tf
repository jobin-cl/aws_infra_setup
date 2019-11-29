data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "this" {
  cidr_block = "${var.cidr}"

  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "${var.vpc_name}"
    billto = "${var.billto}"
  }
}

#Subnets
#Public Subnet
resource "aws_subnet" "public_subnet" {
  count             = "${length(var.public_subnet_cidr)}"
  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = "${var.public_subnet_cidr[count.index]}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "${var.vpc_name}-public-subnet"
    billto = "${var.billto}"
  }
}

#Private Subnet
resource "aws_subnet" "private_subnet" {
  count             = "${length(var.private_subnet_cidr)}"
  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = "${var.private_subnet_cidr[count.index]}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "${var.vpc_name}-private-subnet"
    billto = "${var.billto}"
  }
}

#VPC Elastic IP
resource "aws_eip" "eip" {
  vpc = true

  tags = {
    Name = "${var.vpc_name}-EIP"
    billto = "${var.billto}"
  }
}

#Public Route Table
resource "aws_route_table" "rt_public" {
  vpc_id = "${aws_vpc.this.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "${var.vpc_name}-public-route-table"
    billto = "${var.billto}"
  }
}

#Public Route Table Association
resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnet_cidr)}"
  subnet_id      = "${aws_subnet.public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.rt_public.id}"
}

#Internet Gatway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.this.id}"

  tags = {
    Name = "${var.vpc_name}-IG"
    billto = "${var.billto}"
  }
}

#NatGatways
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.eip.id}"
  subnet_id     = "${element(aws_subnet.public_subnet.*.id, 0)}"

  tags {
    Name = "${var.vpc_name}-NATG"
    billto = "${var.billto}"
  }
}

#Private Route Table
resource "aws_route_table" "rt_private" {
  vpc_id = "${aws_vpc.this.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gw.id}"
  }

  tags {
    Name = "${var.vpc_name}-private-route-table"
    billto = "${var.billto}"
  }
}

#Private Route Table Association
resource "aws_route_table_association" "private_sub" {
  count          = "${length(var.private_subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.rt_private.id}"
}

#NACLs for the VPC
resource "aws_default_network_acl" "default" {
  default_network_acl_id = "${aws_vpc.this.default_network_acl_id}"

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
    Name = "${var.vpc_name}-nacl"
    billto = "${var.billto}"
  }
}