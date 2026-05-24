variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket to store Terraform state"
  type        = string
}

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
  description = "The environment name (dev, staging, prod)"
  type        = string
}
