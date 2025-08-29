# 1. IAM Role para o Control Plane do EKS
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.project_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# 2. IAM Role para os Worker Nodes
resource "aws_iam_role" "eks_node_role" {
  name = "${var.project_name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

# 3. Cluster EKS
resource "aws_eks_cluster" "main" {
  name     = "${var.project_name}-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy_attachment,
  ]
}

# 4. EKS Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.private_subnet_ids

  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 5
    max_size     = 7
    min_size     = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy_attachment,
    aws_iam_role_policy_attachment.eks_cni_policy_attachment,
    aws_iam_role_policy_attachment.ec2_container_registry_read_only,
    aws_iam_role_policy_attachment.grafana_athena_attachment, # Adicionado para garantir a ordem
  ]
}

# --- BLOCO PARA O GRAFANA/ATHENA (IRSA) ---

# 5. Provedor de Identidade OIDC para o Cluster (Pré-requisito para o IRSA)
data "tls_certificate" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

# 6. Política de Permissão para o Grafana Acessar o Athena e o S3
resource "aws_iam_policy" "grafana_athena_policy" {
  name        = "${var.project_name}-grafana-athena-policy"
  description = "Permite que o Grafana consulte o Athena e leia os buckets S3 necessários."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Athena + Glue + PutObject genérico (para resultados)
      {
        Effect = "Allow",
        Action = [
          "athena:GetQueryExecution",
          "athena:GetQueryResults",
          "athena:StartQueryExecution",
          "athena:StopQueryExecution",
          "athena:GetWorkGroup",
          "glue:GetDatabases",
          "glue:GetDatabase",
          "glue:GetTables",
          "glue:GetTable",
          "glue:GetPartitions",
          "s3:PutObject",
          "s3:AbortMultipartUpload"
        ],
        Resource = "*"
      },

      # Ações específicas no bucket de resultados do Athena
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        Resource = [
          var.athena_s3_bucket_arn,
          "${var.athena_s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

# 7. IAM Role Específico para o Pod do Grafana (IRSA)
resource "aws_iam_role" "grafana_role" {
  name = "${var.project_name}-grafana-irsa-role"

  # Política de confiança que permite que a Service Account do Grafana assuma este Role
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        },
        Action    = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            # Garante que apenas a Service Account 'grafana' no namespace 'monitoring' possa usar este Role
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:monitoring:grafana"
          }
        }
      }
    ]
  })
}

# Anexa a política de permissões do Athena a este novo Role do Grafana
resource "aws_iam_role_policy_attachment" "grafana_irsa_athena_attachment" {
  policy_arn = aws_iam_policy.grafana_athena_policy.arn
  role       = aws_iam_role.grafana_role.name
}

# Anexa a política de permissões do Athena ao Role dos Nós (para simplificar, se o IRSA falhar)
resource "aws_iam_role_policy_attachment" "grafana_athena_attachment" {
  policy_arn = aws_iam_policy.grafana_athena_policy.arn
  role       = aws_iam_role.eks_node_role.name
}

# --- FIM DO BLOCO NOVO ---