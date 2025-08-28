variable "project_name" {
  description = "Nome do projeto para usar em tags"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "Lista dos IDs das sub-redes privadas"
  type        = list(string)
}

variable "athena_s3_bucket_arn" {
  description = "O ARN do bucket S3 do Athena para as permissões do Grafana."
  type        = string
}