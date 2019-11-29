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

  tags = "${
    map(
    "Name", "${var.cluster-name}-public-subnet-${data.aws_availability_zones.available.names[count.index]}",
    "kubernetes.io/cluster/${var.cluster-name}" , "owned",
    "kubernetes.io/role/elb" , "1",
    "billto" , "${var.billto}",
    )
  }"
}

#Private Subnet
resource "aws_subnet" "private_subnet" {
  count             = "${length(var.private_subnet_cidr)}"
  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = "${var.private_subnet_cidr[count.index]}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = "${
    map(
    "Name", "${var.cluster-name}-private-subnet-${data.aws_availability_zones.available.names[count.index]}",
    "kubernetes.io/cluster/${var.cluster-name}" , "owned",
    "kubernetes.io/role/internal-elb" , "1",
    "billto" , "${var.billto}",
    )
  }"
}

#EKS Kubernetes Subnet
resource "aws_subnet" "master_subnet" {
  count             = "${length(var.master_subnet_cidr)}"
  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = "${element(var.master_subnet_cidr, count.index)}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags = {
    Name = "${var.cluster-name}-master-${element(data.aws_availability_zones.available.names, count.index)}"
    billto = "${var.billto}"
  }
}

#Worker Nodes
resource "aws_subnet" "worker_subnet" {
  count             = "${length(var.worker_subnet_cidr)}"
  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = "${element(var.worker_subnet_cidr,count.index)}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags = {
    Name = "${var.cluster-name}-worker_${element(data.aws_availability_zones.available.names, count.index)}"
    billto = "${var.billto}"
  }
}

#VPC Elastic IP
resource "aws_eip" "eip" {
  vpc = true

  tags = {
    Name = "${var.cluster-name}-EIP"
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
    Name = "${var.cluster-name}-public-route-table"
    billto = "${var.billto}"
  }
}

#Public Route Table Association

resource "aws_route_table_association" "master" {
  count          = "${length(var.master_subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.master_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.rt_public.id}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnet_cidr)}"
  subnet_id      = "${aws_subnet.public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.rt_public.id}"
}

#Internet Gatway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.this.id}"

  tags = {
    Name = "${var.cluster-name}-IG"
    billto = "${var.billto}"
  }
}

#NatGatways
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.eip.id}"
  subnet_id     = "${element(aws_subnet.master_subnet.*.id, 0)}"

  tags {
    Name = "${var.cluster-name}-NATG"
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
    Name = "${var.cluster-name}-private-route-table"
    billto = "${var.billto}"
  }
}

#Private Route Table Association

resource "aws_route_table_association" "worker" {
  count          = "${length(var.worker_subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.worker_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.rt_private.id}"
}

resource "aws_route_table_association" "private_sub" {
  count          = "${length(var.private_subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.rt_private.id}"
}
