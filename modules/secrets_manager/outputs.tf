output "grafana_secret_arn" {
  value = aws_secretsmanager_secret.grafana_password.arn
}

output "grafana_secret_name" {
  value = aws_secretsmanager_secret.grafana_password.name
}