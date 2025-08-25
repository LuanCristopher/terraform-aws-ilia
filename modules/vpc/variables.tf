variable "project_name" {
  description = "Nome do projeto para usar em tags"
  type        = string
}

variable "aws_region" {
  description = "Região"
  type        = string
}

variable "vpc_cidr" {
  description = "Bloco CIDR para a VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  description = "Lista de blocos CIDR da subnet"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  description = "Lista de blocos CIDR para as sub-nets privadas"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}