resource "random_password" "grafana_admin" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret" "grafana_password" {
  name = "${var.project_name}-grafana-admin-password"
}

resource "aws_secretsmanager_secret_version" "grafana_password_version" {
  secret_id     = aws_secretsmanager_secret.grafana_password.id
  secret_string = random_password.grafana_admin.result
}