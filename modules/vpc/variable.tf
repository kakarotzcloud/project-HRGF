variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "aws_public_subnet" {
  description = "The availability zones to create subnets in"
  type        = map(string)
}

variable "aws_private_subnet" {
  description = "The availability zones to create subnets in"
  type        = map(string)
}

variable "nat_gateway_subnet_cidr" {
  type = string
}

variable "environment" {
  description = "The environment to deploy resources in (e.g., dev, stage, prod)"
  type        = string
}
