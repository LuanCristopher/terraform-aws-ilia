# Módulo EKS – Desafio Ília

Este módulo em **Terraform** cria os recursos necessários para provisionar um cluster **EKS** na AWS.

### Recursos principais:
- **IAM Roles** para o control plane e para os worker nodes.
- **Cluster EKS** com configuração de VPC/Subnets privadas.
- **Node Group** com instâncias `t3.small` (ajustável via variáveis).
- **IRSA (IAM Roles for Service Accounts)** configurado para que o **Grafana** possa acessar o **Athena** e buckets no S3.

### Variáveis principais:
- `project_name`: nome do projeto.
- `private_subnet_ids`: subnets onde os nodes do EKS serão criados.
- `athena_s3_bucket_arn`: bucket S3 usado pelo Athena para armazenar resultados.

### outputs:
- Nome do cluster EKS.
- Informações do Node Group.

---

Este módulo foi utilizado no desafio técnico da Ília como parte do provisionamento da infraestrutura em AWS.
