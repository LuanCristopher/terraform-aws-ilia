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
  athena_s3_bucket_arn = module.athena.s3_bucket_arn
}

module "athena" {
  source = "./modules/athena"

  project_name = var.project_name
  aws_region   = var.aws_region
  test_data_file_path = "${path.module}/data/dados_teste.csv"
  athena_db_name_override = var.athena_db_name
}
