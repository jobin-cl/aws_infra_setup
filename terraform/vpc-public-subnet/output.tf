output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${aws_vpc.create_vpc.id}"
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = "${aws_vpc.create_vpc.cidr_block}"
}
