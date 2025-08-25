# 1 Verifica se a var chega ao módulo (referencia var = OK p/ assert)
run "vars_are_wired" {
  command = plan

  module { source = "./" }

  variables {
    aws_region = "us-east-1"
  }

  assert {
    condition     = can(var.aws_region) && var.aws_region == "us-east-1"
    error_message = "A variável aws_region não foi propagada corretamente para o módulo."
  }
}

# 2 Garante que o output 'vpc_id' está DECLARADO (no plan o valor pode ser unknown)
run "declares_vpc_id_output" {
  command = plan

  module { source = "./" }

  variables {
    aws_region = "us-east-1"
  }

  assert {
    condition     = can(output.vpc_id)
    error_message = "O output 'vpc_id' não está declarado no módulo raiz."
  }
}