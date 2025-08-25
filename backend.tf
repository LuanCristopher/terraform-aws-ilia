terraform {
  backend "s3" {
    bucket         = "tf-state-ilia-desafio-s3-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks-tf-state-ilia-desafio-s3-state"
    encrypt        = true
  }
}