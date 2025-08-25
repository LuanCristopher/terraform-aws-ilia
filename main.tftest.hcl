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