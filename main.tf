module "s3_backend" {
  source = "./modules/s3_backend"

  bucket_name = "tf-state-${var.project_name}-s3-state"
  region      = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  aws_region   = var.aws_region
}

module "eks" {
  source = "./modules/eks"

  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}