# 1. Bucket S3 para armazenar os dados de teste e os resultados das consultas do Athena
resource "aws_s3_bucket" "athena_bucket" {
  bucket = "${var.project_name}-athena-data-${random_id.bucket_suffix.hex}"
}

# Adiciona o arquivo de dados de teste ao bucket
resource "aws_s3_object" "test_data" {
  bucket = aws_s3_bucket.athena_bucket.id
  key    = "test-data/dados_teste.csv"
  source = var.test_data_file_path
  etag   = filemd5(var.test_data_file_path)
}

# 2. Banco de dados no AWS Glue (o catálogo de dados do Athena)
resource "aws_glue_catalog_database" "athena_db" {
  name = var.athena_db_name_override
}

# 3. Tabela no AWS Glue que define a estrutura dos nossos dados
resource "aws_glue_catalog_table" "athena_table" {
  name          = "iliatable"
  database_name = aws_glue_catalog_database.athena_db.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "EXTERNAL"            = "TRUE",
    "csv_classifier"      = "csv",
    "skip.header.line.count" = "1"
  }

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.athena_bucket.id}/test-data/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "OpenCSVSerde"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "separatorChar" = ","
      }
    }

    columns {
      name = "timestamp"
      type = "string"
    }
    columns {
      name = "host"
      type = "string"
    }
    columns {
      name = "region"
      type = "string"
    }
    columns {
      name = "cpu_utilization"
      type = "double"
    }
    columns {
      name = "memory_utilization"
      type = "double"
    }
  }
}

# 4. Configuração do Athena
#resource "aws_athena_database" "main" {
#  name   = aws_glue_catalog_database.athena_db.name
#  bucket = aws_s3_bucket.athena_bucket.bucket
#}

resource "aws_athena_workgroup" "main" {
  name = "${var.project_name}-workgroup"
  configuration {
    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_bucket.bucket}/query-results/"
    }
  }
}

# Gera um sufixo aleatório para garantir que o nome do bucket S3 seja único
resource "random_id" "bucket_suffix" {
  byte_length = 8
}