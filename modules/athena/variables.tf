variable "project_name" {
  description = "Nome do projeto para usar em tags e nomes de recursos."
  type        = string
}

variable "aws_region" {
  description = "Região da AWS para criar os recursos."
  type        = string
}

variable "test_data_file_path" {
  description = "Caminho para o arquivo CSV de dados de teste."
  type        = string
}

variable "athena_db_name_override" {
  description = "Nome específico para o banco de dados do Glue/Athena."
  type        = string
}