module "s3_backend" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

module "vpc" {
  source                  = "./modules/vpc"
  vpc_cidr                = var.vpc_cidr
  aws_private_subnet      = var.aws_private_subnet
  aws_public_subnet       = var.aws_public_subnet
  nat_gateway_subnet_cidr = var.nat_gateway_subnet_cidr
  environment             = var.environment
}
