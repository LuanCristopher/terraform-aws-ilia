output "cluster_name" {
  description = "nome do cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "endpoint do servidor"
  value       = aws_eks_cluster.main.endpoint
}

output "grafana_role_name" {
  description = "Nome da IAM Role do Grafana para anexar outras políticas."
  value       = aws_iam_role.grafana_role.name
}

output "oidc_provider_arn" {
  description = "ARN do OIDC Provider do cluster EKS para uso com IRSA."
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "eks_node_role_name" {
  description = "Nome da IAM Role usada pelos nós do EKS."
  value       = aws_iam_role.eks_node_role.name
}

output "oidc_provider_url" {
  description = "URL do OIDC Provider do cluster EKS."
  value       = aws_iam_openid_connect_provider.eks.url
}