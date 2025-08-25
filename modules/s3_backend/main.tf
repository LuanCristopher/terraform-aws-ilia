# O bucket S3 para armazenar o estado remoto
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name
}

# Habilita o versionamento para ter um histórico de alterações
resource "aws_s3_bucket_versioning" "versioning_enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# A tabela no DynamoDB para evitar conflitos (state locking)
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks-${var.bucket_name}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}