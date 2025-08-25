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