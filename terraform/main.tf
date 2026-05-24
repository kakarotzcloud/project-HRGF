module "s3_backend" {
  source = "./modules/s3"

  bucket_name = var.bucket_name
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr                = var.vpc_cidr
  aws_private_subnet      = var.aws_private_subnet
  aws_public_subnet       = var.aws_public_subnet
  nat_gateway_subnet_cidr = var.nat_gateway_subnet_cidr
  environment             = var.environment
}

module "iam" {
  source = "./modules/iam"

  environment = var.environment
}

module "eks" {
  source = "./modules/eks"

  environment             = var.environment
  eks_cluster_role_arn    = module.iam.eks_cluster_role_arn
  eks_node_group_role_arn = module.iam.eks_node_group_role_arn
  private_subnet_ids_list = module.vpc.private_subnet_ids_list
  eks_version             = var.eks_version
  instance_types          = var.instance_type

  depends_on = [
    module.iam,
    module.vpc
  ]
}

# module "ec2" {
#   source = "./modules/ec2"

#   environment            = var.environment
#   public_subnet_ids_list = module.vpc.public_subnet_ids_list
#   vpc_id                 = module.vpc.vpc_id

#   depends_on = [
#     module.vpc
#   ]
# }


