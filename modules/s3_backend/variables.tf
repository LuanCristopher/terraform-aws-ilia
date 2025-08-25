variable "bucket_name" {
  description = "S3 para state"
  type        = string
}

variable "region" {
  description = "Região"
  type        = string
  default     = "us-east-1"
}