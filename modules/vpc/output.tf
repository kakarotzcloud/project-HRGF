# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = { for subnet in aws_subnet.public : subnet.availability_zone => subnet.id }
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = { for subnet in aws_subnet.private : subnet.availability_zone => subnet.id }
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of public subnets"
  value       = { for subnet in aws_subnet.public : subnet.availability_zone => subnet.cidr_block }
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of private subnets"
  value       = { for subnet in aws_subnet.private : subnet.availability_zone => subnet.cidr_block }
}

# Gateway Outputs
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "nat_gateway_eip" {
  description = "The Elastic IP address of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

# Route Table Outputs
output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private.id
}
