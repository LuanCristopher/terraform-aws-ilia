variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto para ser usado como prefixo nos recursos."
  type        = string
  default     = "ilia-desafio"
}