# main.tftest.hcl

###############################################################################
# 1 Smoke test: garante que o "terraform plan" do módulo raiz roda sem erro.
###############################################################################
run "smoke_plan" {
  command = plan

  module {
    # Testa o módulo raiz (./)
    source = "./"
  }

  # Coloque aqui as variáveis mínimas para o plan funcionar no seu root module
  variables {
    aws_region = "us-east-1"
  }

  # Se o plan passar, este assert sempre passa.
  assert {
    condition     = true
    error_message = "Smoke test falhou: o plan não completou com sucesso."
  }
}

###############################################################################
# 2 Vars wired: confere que a variável chegou ao módulo (barato e útil).
###############################################################################
run "vars_are_wired" {
  command = plan

  module { source = "./" }

  variables {
    aws_region = "us-east-1"
  }

  assert {
    condition     = var.aws_region == "us-east-1"
    error_message = "A variável aws_region não foi propagada corretamente para o módulo."
  }
}

###############################################################################
# 3 Output declarado: verifica que existe um output chamado "vpc_id".
#    No "plan", o valor pode estar unknown; por isso só checamos a existência.
###############################################################################
run "declares_vpc_id_output" {
  command = plan

  module { source = "./" }

  variables {
    aws_region = "us-east-1"
  }

  assert {
    # "can(output.vpc_id)" passa se o output está declarado (mesmo se unknown no plan).
    condition     = can(output.vpc_id)
    error_message = "O output 'vpc_id' não está declarado no módulo raiz."
  }
}