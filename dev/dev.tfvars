bucket_name = "hrgf-terraform-dev-backend"
vpc_cidr    = "10.0.0.0/16"
aws_private_subnet = {
  "10.0.0.0/18"  = "ap-south-1a"
  "10.0.64.0/18" = "ap-south-1b"
}
aws_public_subnet = {
  "10.0.128.0/18" = "ap-south-1a"
  "10.0.192.0/18" = "ap-south-1b"
}
nat_gateway_subnet_cidr = "10.0.128.0/18"
environment             = "dev"
