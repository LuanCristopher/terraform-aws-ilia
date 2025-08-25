output "cluster_name" {
  description = "nome do cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "endpoint do servidor"
  value       = aws_eks_cluster.main.endpoint
}